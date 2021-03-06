from __future__ import print_function
import json
from flask import jsonify, request
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

import requests

from util import (
    create_user,
    get_user_all_friend_dicts,
    get_user_all_friend_request_dicts,
    get_user_all_vaccination_dicts,
    create_link_for_user,
    get_given_vaccination_dicts,
    get_link_vaccination_ids,
    get_user_dict,
    pretty_name,
    update_friend_request,
    get_vaccine_statistics_list,
    get_countries_list,
    get_vaccines_list,
    get_dates,
)
from hello import app
import dbops
import twilio_api
import mailjet_api

SCOPES = ["https://www.googleapis.com/auth/contacts.readonly"]


def get_response(res, status):
    res["status"] = status

    result = jsonify(res)
    result.status_code = 200

    result.headers.add(
        "Access-Control-Allow-Origin", "*"
    )  # needed for avoiding CORS policy
    result.headers.add(
        "Access-Control-Allow-Headers",
        "X-Requested-With, Content-Type, Accept, Origin, Authorization",
    )
    result.headers.add(
        "Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, PATCH, OPTIONS"
    )

    return result


@app.route("/add_user", methods=["POST"])
def add_user():
    name = request.json.get("name")
    country_id = request.json.get("country_id")
    dbops.add_user(name, country_id=country_id)
    return get_response({}, 200)


@app.route("/user", methods=["GET"])
def get_user():
    if "google_id" not in request.args:
        return get_response({"error": "No google_id provided"}, 400)
    google_id = request.args["google_id"]
    user = dbops.get_user_from_google_id(google_id)
    if user is None:
        return get_response({"error": "User not found"}, 400)
    res = {
        "name": user.name,
        "country_id": user.country_id,
        "privacy": user.visibility,
    }
    return get_response(res, 200)


@app.route("/user/friends", methods=["GET"])
def get_user_friends():
    google_id = request.args["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id

    friend_dicts = get_user_all_friend_dicts(user_id)
    #
    res = {"friends": friend_dicts}

    # static_friends_data = {
    #     "friends": [
    #         {
    #             "id": "123",
    #             "name": "Ayberk Uslu",
    #             "age": 20,
    #             "with_friends_since": "2015-3-3 12:00:00"
    #             "vaccines": [
    #                 {
    #                     "vaccination_id": 1234,
    #                     "vaccine_id": 0,
    #                     "name": "COVID-191",
    #                     "date": "2021-3-3 15:12:06",
    #                     "dose": 1,
    #                     "vaccine_point": "Ankara Merkez",
    #                     "valid_until": "2022-3-3 15:12:06",
    #                 },
    #                 {
    #                     "vaccination_id": 1235,
    #                     "vaccine_id": 1,
    #                     "name": "COVID-192",
    #                     "date": "2021-3-3 15:12:06",
    #                     "dose": 1,
    #                     "vaccine_point": "Ankara Merkez",
    #                     "valid_until": "2022-3-3 15:12:06",
    #                 },
    #                 {
    #                     "vaccination_id": 1236,
    #                     "vaccine_id": 2,
    #                     "name": "COVID-139",
    #                     "date": "2021-3-3 15:12:06",
    #                     "dose": 1,
    #                     "vaccine_point": "Ankara Merkez",
    #                     "valid_until": "2022-3-3 15:12:06",
    #                 },
    #                 {
    #                     "vaccination_id": 1237,
    #                     "vaccine_id": 3,
    #                     "name": "COVID-194",
    #                     "date": "2021-3-3 15:12:06",
    #                     "dose": 1,
    #                     "vaccine_point": "Ankara Merkez",
    #                     "valid_until": "2022-3-3 15:12:06",
    #                 },
    #             ],
    #         }
    #     ]
    # }

    # return get_response(static_friends_data, 200)
    return get_response(res, 200)


@app.route("/google/my-friends", methods=["GET"])
def get_google_friends():
    google_id = request.args["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id

    google_token = dbops.get_user_google_token(user_id)
    google_mobile_access_token = dbops.get_user_google_mobile_access_token(user_id)

    results = None

    if google_mobile_access_token:
        URL = "https://people.googleapis.com/v1/people/me/connections"

        params = {
            "personFields": "names,phoneNumbers,emailAddresses",
            "access_token": google_mobile_access_token,
            "pageSize": 1000,
        }

        response = requests.get(url=URL, params=params)
        if response.ok:
            results = response.json()

    if results is None:
        creds = None

        if google_token is not None:
            creds = Credentials.from_authorized_user_info(
                json.loads(google_token), SCOPES
            )

        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
                dbops.add_user_google_token(user_id, creds.to_json())
            else:
                client_secret_str = os.environ["GOOGLE_CLIENT_SECRET"]
                client_secret = json.loads(client_secret_str)

                flow = InstalledAppFlow.from_client_config(client_secret, SCOPES)

                kwargs = {}
                kwargs.setdefault("prompt", "consent")
                flow.redirect_uri = flow._OOB_REDIRECT_URI
                auth_url, _ = flow.authorization_url(**kwargs)

                res = {
                    "is_auth": False,
                    "auth_url": auth_url,
                    "friends": [],
                }
                return get_response(res, 200)

        service = build("people", "v1", credentials=creds)

        results = (
            service.people()
                .connections()
                .list(
                resourceName="people/me",
                pageSize=1000,
                personFields="names,emailAddresses,phoneNumbers",
            )
                .execute()
        )

    connections = results.get("connections", [])

    contacts = []

    for person in connections:
        names = person.get("names", [])
        name = None
        email = None
        phone = None
        if names:
            name = names[0].get("displayName")
        emails = person.get("emailAddresses", [])
        if emails:
            email = emails[0].get("value")
        phones = person.get("phoneNumbers", [])
        if phones:
            phone = phones[0].get("canonicalForm")

        name = pretty_name(name)

        contact_names = set()

        if name and name not in contact_names and (email or phone):
            friendship = None
            contact_user = None

            if email:
                contact_user = dbops.get_user_from_email(email)
                if contact_user is not None:
                    friendship = dbops.get_friendship(user_id, contact_user.id)
            if friendship is None:
                contacts.append(
                    {
                        "name": name,
                        "email": email or "",
                        "phone": phone or "",
                        "is_user": contact_user is not None,
                    }
                )
                contact_names.add(name)

    data = {
        "is_auth": True,
        "auth_url": "",
        "friends": contacts,
    }

    return get_response(data, 200)


@app.route("/google/remove-auth-contact", methods=["GET"])
def remove_google_auth_contact():
    google_id = request.args["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id

    dbops.add_user_google_token(user_id, None)
    return get_response({}, 200)


@app.route("/google/auth-contact", methods=["POST"])
def get_google_auth_contact():
    google_id = request.json["google_id"]
    google_code = request.json["google_code"]

    user_id = dbops.get_user_from_google_id(google_id).id

    client_secret_str = os.environ["GOOGLE_CLIENT_SECRET"]
    client_secret = json.loads(client_secret_str)

    flow = InstalledAppFlow.from_client_config(client_secret, SCOPES)

    flow.redirect_uri = flow._OOB_REDIRECT_URI

    code = google_code

    try:
        flow.fetch_token(code=code)
    except Exception:
        return get_response({"error": "The code you pasted is invalid"}, 400)

    creds = flow.credentials

    dbops.add_user_google_token(user_id, creds.to_json())

    return get_response({}, 200)


@app.route("/user/codes", methods=["GET"])
def get_user_codes():
    google_id = request.args["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id

    res = {"my_vaccines": get_user_all_vaccination_dicts(user_id)}

    # code_data = {
    #     "my_vaccines": [
    #         {
    #             "vaccination_id": 0,
    #             "vaccine_id": 0,
    #             "name": "COVID-191",
    #             "date": "2021-3-3 15:12:06",
    #             "dose": 1,
    #             "vaccine_point": "Ankara Merkez",
    #             "valid_until": "2022-3-3 15:12:06",
    #         },
    #         {
    #             "vaccination_id": 1,
    #             "vaccine_id": 1,
    #             "name": "COVID-192",
    #             "date": "2021-3-3 15:12:06",
    #             "dose": 1,
    #             "vaccine_point": "Ankara Merkez",
    #             "valid_until": "2022-3-3 15:12:06",
    #         },
    #         {
    #             "vaccination_id": 2,
    #             "vaccine_id": 2,
    #             "name": "COVID-139",
    #             "date": "2021-3-3 15:12:06",
    #             "dose": 1,
    #             "vaccine_point": "Ankara Merkez",
    #             "valid_until": "2022-3-3 15:12:06",
    #         },
    #         {
    #             "vaccination_id": 3,
    #             "vaccine_id": 3,
    #             "name": "COVID-194",
    #             "date": "2021-3-3 15:12:06",
    #             "dose": 1,
    #             "vaccine_point": "Ankara Merkez",
    #             "valid_until": "2022-3-3 15:12:06",
    #         },
    #     ]
    # }

    # return get_response(code_data, 200)
    return get_response(res, 200)


@app.route("/friend-request", methods=["POST"])
def add_friend_request():
    google_id = request.json["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id
    friend_email = request.json["friend_email"]
    friend_user = dbops.get_user_from_email(friend_email)
    if friend_user is None:
        return get_response({"error": "User with given email is not found"}, 400)
    friend_id = friend_user.id

    if friend_id == user_id:
        return get_response({"error": "You can't add yourself as friend"}, 400)

    friendship = dbops.get_friendship(user_id, friend_id)
    if friendship is not None:
        return get_response({"error": "You're already friends"}, 400)

    friend_request = dbops.get_friend_request_between(user_id, friend_id)
    if friend_request is not None:
        return get_response(
            {"error": "You have an existing friend request to this person"}, 400
        )

    friend_request_reversed = dbops.get_friend_request_between(friend_id, user_id)
    if friend_request_reversed is not None:
        return get_response(
            {"error": "This person already sent you a request that you can accept"}, 400
        )

    dbops.add_friend_request(user_id, friend_id)

    return get_response({}, 200)


@app.route("/friend-requests", methods=["GET"])
def get_user_friend_requests():
    google_id = request.args["google_id"]
    user_id = dbops.get_user_from_google_id(google_id).id

    res = {"friend_requests": get_user_all_friend_request_dicts(user_id)}

    # temp_data = {
    #     "friend_requests": [
    #         {
    #             "request_id": "friend_request.id1",
    #             "requester_id": "requestee_user.id1",
    #             "requester_email": "requestee_user.email1",
    #             "requester_name": "requestee_user.name1",
    #             "created": "friend_request.created1",
    #         },
    #         {
    #             "request_id": "friend_request.id2",
    #             "requester_id": "requestee_user.id2",
    #             "requester_email": "requestee_user.email2",
    #             "requester_name": "requestee_user.name2",
    #             "created": "friend_request.created2",
    #         },
    #         {
    #             "request_id": "friend_request.id3",
    #             "requester_id": "requestee_user.id3",
    #             "requester_email": "requestee_user.emai3",
    #             "requester_name": "requestee_user.name3",
    #             "created": "friend_request.created3",
    #         },
    #     ]
    # }

    # return get_response(temp_data, 200)
    return get_response(res, 200)


@app.route("/user-info", methods=["GET"])
def user_info():
    google_id = request.args["google_id"]
    user = dbops.get_user_from_google_id(google_id)

    res = {"info": get_user_dict(user.id)}

    return get_response(res, 200)


@app.route("/update-user-info", methods=["POST"])
def fill_user_info():
    google_id = request.json["google_id"]
    res = {"new_user": create_user(google_id)}

    email = request.json.get("email")
    facebook_id = request.json.get("facebook_id")
    name = request.json.get("name")
    age = request.json.get("age")
    country_name = request.json.get("country_name")
    is_update = request.json.get("is_update")

    access_token = request.json.get("access_token")

    print("Access token:", access_token)

    user = dbops.get_user_from_google_id(google_id)

    if access_token:
        user.google_mobile_access_token = access_token
    if email:
        user.email = email
    if facebook_id:
        user.facebook_id = facebook_id
    if name and (not user.name or is_update):
        user.name = name
    if age:
        user.age = int(age)
    if country_name:
        country = dbops.get_country_by_name(country_name)
        if country is not None:
            user.country_id = country.id

    dbops.session.commit()

    return get_response(res, 200)


@app.route("/accept-friend-request", methods=["POST"])
def accept_friend_request():
    request_id = request.json["request_id"]
    update_friend_request(request_id, accept=True)
    return get_response({}, 200)


@app.route("/reject-friend-request", methods=["POST"])
def reject_friend_request():
    request_id = request.json["request_id"]
    update_friend_request(request_id, accept=False)
    return get_response({}, 200)


@app.route("/set-privacy", methods=["POST"])
def set_vaccine_privacy():
    vaccination_id = request.json["vaccination_id"]
    new_privacy = request.json["new_privacy"]
    vaccination = dbops.get_vaccination(vaccination_id)
    vaccination.visibility = new_privacy

    dbops.session.commit()

    return get_response({}, 200)


@app.route("/get-privacy", methods=["GET"])
def get_vaccine_privacy():
    vaccination_id = request.args["vaccination_id"]
    vaccination = dbops.get_vaccination(vaccination_id)
    res = {"privacy_setting": vaccination.visibility}
    return get_response(res, 200)


@app.route("/create-link", methods=["POST"])
def create_link():
    google_id = request.json["google_id"]
    vaccination_ids = request.json["vaccination_ids"].copy()

    user_id = dbops.get_user_from_google_id(google_id).id
    link = create_link_for_user(user_id, vaccination_ids)
    res = {"link": link}
    # {"link": jdf83kggdg923ks}
    return get_response(res, 200)


@app.route("/get-vaccinations-from-link", methods=["GET"])
def get_vaccinations_from_link():
    link = request.args["link"]
    vaccination_ids = get_link_vaccination_ids(link)
    res = {"vaccinations": get_given_vaccination_dicts(vaccination_ids)}

    return get_response(res, 200)


@app.route("/invite-email", methods=["POST"])
def invite_email():
    google_id = request.json["google_id"]
    email = request.json["friend_email"]
    name = request.json["name"]

    inviter = dbops.get_user_from_google_id(google_id)

    # # Let's not spam people
    # if email not in [
    #     "erdemkiraz@gmail.com",
    #     "usluayberk1998@gmail.com",
    #     "ayberkuslu0@gmail.com",
    #     "ayberkuslu1998@gmail.com",
    # ]:
    #     email = "erdemkiraz@gmail.com"

    body = (
        "Hi {},<br><br>{} is inviting you to join Asi Karnesi! "
        "Sign up to Asi Karnesi at https://asi-karnesi.netlify.app/ "
        "to see vaccination status of your friends!".format(name, inviter.name)
    )

    mailjet_api.send_email(email, name, body)  # TODO: uncomment in production

    return get_response({"message": "Sent email invite to {}".format(email)}, 200)


@app.route("/4383e9c5b061cbcb400dacfd3ad83e9a.txt", methods=["GET", "POST"])
def check_file_mailjet():
    return get_response({}, 200)


@app.route("/2f8ba22d3a84c56ed67972ec2574e2d8.txt", methods=["GET", "POST"])
def check_file_mailjet_new():
    return get_response({}, 200)


@app.route("/invite-sms", methods=["POST"])
def invite_sms():
    google_id = request.json["google_id"]
    phone = request.json["friend_phone"]
    name = request.json["name"]

    inviter = dbops.get_user_from_google_id(google_id)

    message = (
        "Hi {}, {} is inviting you to join Asi Karnesi! "
        "Sign up to Asi Karnesi at https://asi-karnesi.netlify.app/ "
        "to see vaccination status of your friends!".format(name, inviter.name)
    )

    # Let's not spam people
    if phone not in ["+905542638860", "+905549060502"]:
        phone = "+905542638860"

    twilio_api.send_sms(phone, message)  # TODO: uncomment in production

    return get_response({"message": "Sent text invite to {}".format(phone)}, 200)


@app.route("/populate-demo-db", methods=["GET"])
def populate_demo_db():
    import demo_db

    demo_db.populate()

    return get_response({}, 200)


@app.route("/rollback", methods=["GET"])
def rollback_db():
    try:
        dbops.session.rollback()
    except Exception:
        pass

    try:
        dbops.session.commit()
    except Exception:
        pass

    return get_response({}, 200)


@app.route("/get-vaccine-statistics", methods=["GET"])
def get_vaccine_statistics():
    country_id = request.args.get("country_id")
    age_from = request.args.get("age_from")
    age_to = request.args.get("age_to")
    vaccine = request.args.get("vaccine_id")

    vaccine_dates = get_vaccine_statistics_list(country_id, vaccine, age_from, age_to)

    return get_response({"vaccines": vaccine_dates}, 200)


# @app.route("/get-multiple-vaccine-statistics", methods=["POST"])
# def get_multiple_vaccine_statistics():
#     country_ids = request.json.get("country_ids", [])
#     age_from = request.json.get("age_from", [])
#     age_to = request.json.get("age_to", [])
#     vaccines = request.json.get("vaccine_ids", [])

#     vaccine_dates = get_multiple_vaccine_statistics_list(
#         country_id, vaccine, age_from, age_to
#     )

#     return get_response({"vaccines": vaccine_dates}, 200)


# CITIES = [
#     Paris,
#     London,
#     Ankara,
#     Munich,
#     Konya,
#     New York,
#     Istanbul,
#     Ankara,
# ]
#
# @app.route("/all-city-names", methods=["GET"])
# def all_city_names():
#     return get_response({"city_names": CITIES}, 200)


@app.route("/daily-vaccination-table", methods=["GET"])
def daily_vaccination_table():
    # daily_vaccinations = get_daily_vaccinations()
    f = open('daily_covid_statistics.json')
    world_daily_and_weekly_covid_cases = json.load(f)
    dates = get_dates()
    data = {"daily_vaccinations": []}

    for date in dates:
        data["daily_vaccinations"].append({
            "day": date, "vaccination_count": 5000,  ## todo : just add vaccination count from db
            "covid_statistics": world_daily_and_weekly_covid_cases[date]
        })

    return get_response(data, 200)

    # return get_response({"daily_vaccinations": daily_vaccinations}, 200)


@app.route("/covid-vaccine-table", methods=["GET"])
def covid_vaccine_table():
    data = {
        "vaccine_table": [
            {"name": "Covid-19 Biontech", "count": 1},
            {"name": "Covid-19 Moderna", "count": 5},
        ]
    }

    return get_response(data, 200)

    # return get_response({"vaccines": vaccine_dates}, 200)


CITY_POPULATIONS = {
    "Paris": 2_161_000,
    "London": 8_982_000,
    "Munich": 1_472_000,
    "Konya": 2_161_000,
    "New York": 8_149_000,
    "Istanbul": 15_460_000,
    "Ankara": 5_663_000,
    "Los Angeles": 3_967_000,
    "Tel Aviv": 435_000,
}


# name : name of the city , population : total #of people in city, count : total # of people vaccinated
@app.route("/city-vaccination-table", methods=["GET"])
def city_vaccination_table():
    data = {
        "city_table": [
            {"name": "Ankara", "population": CITY_POPULATIONS["Ankara"], "count": 1500000},
            {"name": "Istanbul", "population": CITY_POPULATIONS["Istanbul"], "count": 3200000},
            {"name": "Konya", "population": CITY_POPULATIONS["Konya"], "count": 2000},
        ]
    }

    return get_response(data, 200)


@app.route("/city-risk-table", methods=["GET"])
def city_risk_table():
    data = {
        "city_table": [
            {"name": "Ankara", "count": 0.42},
            {"name": "Istanbul", "count": 0.5},
            {"name": "Konya", "count": 0.7},
        ]
    }

    return get_response(data, 200)

    # return get_response({"vaccines": vaccine_dates}, 200)


@app.route("/get-countries", methods=["GET"])
def get_countries():
    countries = get_countries_list()
    return get_response({"countries": countries}, 200)


@app.route("/get-vaccines", methods=["GET"])
def get_vaccines():
    vaccines = get_vaccines_list()
    return get_response({"vaccines": vaccines}, 200)


@app.route("/health-check", methods=["GET"])
def health_check():
    return get_response({}, 200)


if __name__ == "__main__":
    app.run(debug=True)

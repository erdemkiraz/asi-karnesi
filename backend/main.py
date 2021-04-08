from flask import jsonify, request
import json

from util import *

from util import (
    get_user_all_friend_dicts,
    get_user_all_friend_request_dicts,
    get_user_all_vaccination_dicts,
    create_link_for_user,
    get_given_vaccination_dicts,
    get_link_vaccination_ids,
)
from hello import app
import dbops


def get_response(res, status):
    result = jsonify(res)
    result.status_code = status

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
    if "id" not in request.args:
        return get_response({"error": "No user id provided"}, 400)
    id = request.args["id"]
    user = dbops.get_user(id)
    if user is None:
        return get_response({"error": "User not found"}, 400)
    res = {
        "name": user.name,
        "country_id": user.country_id,
        "privacy": user.visibility,
    }
    return get_response(res, 200)


@app.route("/basic_test")
def hello_world():
    try:
        # dbops.add_country("turkeyq")
        # turkey = dbops.get_country_by_name("turkeyq")
        # print("id:", turkey)
        dbops.add_user(name="from-db-development-testing")
        user = dbops.get_user_by_name("Korili Pokybird")
    except Exception as e:
        print("Oops!", e.__class__, "occurred.")
        return get_response("error", 500)

    return get_response("Hello Worldqqqasd!", 200)


@app.route("/development_test")
def test_development():
    try:
        res = {
            "test_user": get_user_dict(2)
        }
    except Exception as e:
        print("Oops!", e.__class__, "occurred.")
        return get_response("error", 500)

    return get_response(res, 200)


@app.route("/user/friends", methods=["GET"])
def get_user_friends():
    user_id = request.args["google_id"] # TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id

    # friend_dicts = get_user_all_friend_dicts(user_id)
    #
    # res = {"friends": friend_dicts}

    # TODO : when real data is avaliable, use "res" and comment static data.
    static_friends_data = {"friends": [{
        "id": "123",
        "name": "Ayberk Uslu",
        "age": 20,
        "vaccines": [
            {
                "vaccination_id": 1234,
                "vaccine_id": 0,
                "name": "COVID-191",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06"
            },
            {
                "vaccination_id": 1235,
                "vaccine_id": 1,
                "name": "COVID-192",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06"
            },
            {
                "vaccination_id": 1236,
                "vaccine_id": 2,
                "name": "COVID-139",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06"
            },
            {
                "vaccination_id": 1237,
                "vaccine_id": 3,
                "name": "COVID-194",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06"
            }
        ]
    }
    ]
    }

    return get_response(static_friends_data, 200)
    # return get_response(res, 200)


@app.route("/user/codes", methods=["GET"])
def get_user_codes():
    user_id = request.args["google_id"] # TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id

    # res = {"my_vaccines": get_user_all_vaccination_dicts(user_id)}

#TODO : use real data when it is available. comment the code data and uncomment the res
    code_data = {
        "my_vaccines": [
            {
                "vaccination_id": 0,
                "vaccine_id": 0,
                "name": "COVID-191",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06",
            },
            {
                "vaccination_id": 1,
                "vaccine_id": 1,
                "name": "COVID-192",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06",
            },
            {
                "vaccination_id": 2,
                "vaccine_id": 2,
                "name": "COVID-139",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06",
            },
            {
                "vaccination_id": 3,
                "vaccine_id": 3,
                "name": "COVID-194",
                "date": "2021-3-3 15:12:06",
                "dose": 1,
                "vaccine_point": "Ankara Merkez",
                "valid_until": "2022-3-3 15:12:06",
            },
        ]
    }

    return get_response(code_data, 200)
    # return get_response(res, 200)


@app.route("/friend-request", methods=["POST"])
def add_friend_request():
    user_id = request.json["google_id"] # TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id
    friend_id = request.json["friend_id"]  # TODO : friend id is not sent, should be removed. requests should be handled by email
    friend_email = request.json["friend_email"]
    dbops.add_friend_request(user_id, friend_id)

    return get_response({}, 200)


@app.route("/friend-requests", methods=["GET"])
def get_user_friend_requests():
    user_id = request.args["google_id"]# TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id

    # res = {
    #     "friend_requests": get_user_all_friend_request_dicts(user_id)
    # }  # TODO : requester_email should be provided, example data is given

    temp_data = {
        "friend_requests": [
            {
                "request_id": "friend_request.id1",
                "requester_id": "requestee_user.id1",
                "requester_email": "requestee_user.email1",
                "requester_name": "requestee_user.name1",
                "created": "friend_request.created1",
            },
            {
                "request_id": "friend_request.id2",
                "requester_id": "requestee_user.id2",
                "requester_email": "requestee_user.email2",
                "requester_name": "requestee_user.name2",
                "created": "friend_request.created2",
            },
            {
                "request_id": "friend_request.id3",
                "requester_id": "requestee_user.id3",
                "requester_email": "requestee_user.emai3",
                "requester_name": "requestee_user.name3",
                "created": "friend_request.created3",
            },
        ]
    }

    return get_response(temp_data, 200)
    # return get_response(res, 200)


# @app.route("/login", methods=["GET"])
# def get_user_friend_requests():
#     email = request.args["email"]
#     res = {"google_id": get_or_create_user(email)}

#     res = {"google_id": 1234234}
#     return get_response(res, 200)


@app.route("/accept-friend-request", methods=["POST"])
def accept_friend_request():
    request_id = request.json["request_id"]
    accept_friend_request(request_id)
    return get_response({}, 200)


@app.route("/reject-friend-request", methods=["POST"])
def reject_friend_request():
    request_id = request.json["request_id"]
    reject_friend_request(request_id)
    return get_response({}, 200)


@app.route("/set-privacy", methods=["POST"])
def set_vaccine_privacy():
    # user_id = request.json["user_id"]
    vaccination_id = request.json["vaccination_id"]  # TODO : set privacy by vaccination_id, not user_id
    new_privacy = request.json["new_privacy"]
    user_id = request.json["google_id"] # TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id
    user = dbops.get_user(user_id)
    user.visilibty = new_privacy

    return get_response({}, 200)


@app.route("/get-privacy", methods=["GET"])
def get_vaccine_privacy():
    user_id = request.args["vaccination_id"]  # TODO : get privacy by vaccination_id, not user_id
    # user_id = request.args["user_id"]


    # user = dbops.get_user(user_id)
    # res = {"privacy_setting": user.visibility}

# TODO : when real data is avaliable, comment this static data, and use "res"
    static_data = {
        "privacy_setting": 2
    }
    # return get_response(res, 200)
    return get_response(static_data, 200)


@app.route("/create-link", methods=["POST"])
def create_link():
    user_id = request.json["google_id"] # TODO : check the parameter name, frontend sends google_id as an user _id, so backend should convert google_id to user_id
    vaccination_ids = request.json["vaccination_ids"].copy()

    # link = create_link_for_user(user_id, vaccination_ids)
    # res = {"link": link}

    # TODO : when real data is avaliable, comment this static data, and use "res"
    static_data = {
        "link": "vaccination_link.com"
    }

    return get_response(static_data, 200)
    # return get_response(res, 200)


@app.route("/get-vaccinations-from-link", methods=["GET"])
def get_vaccinations_from_link():
    link = request.args["link"]
    vaccination_ids = get_link_vaccination_ids(link)
    res = {"vaccinations": get_given_vaccination_dicts(vaccination_ids)}


    return get_response(res, 200)


if __name__ == "__main__":
    app.run()

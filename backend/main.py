from flask import jsonify, request

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
    dbops.add_country("turkeyq")
    turkey = dbops.get_country_by_name("turkeyq")
    print("id:", turkey)
    dbops.add_user("erdemsu", country_id=turkey.id)
    erdem = dbops.get_user_by_name("erdem")
    print(erdem.id, erdem)
    return get_response("Hello Worldqqqasd!", 200)


@app.route("/user/friends", methods=["GET"])
def get_user_friends():
    user_id = request.args["user_id"]

    friend_dicts = get_user_all_friend_dicts(user_id)

    res = {"friends": friend_dicts}

    return get_response(res, 200)

    # friend_data = {
    #     "friends": [
    #         {
    #             "id": 0,
    #             "name": "Ayberk",
    #             "surname": "Uslu",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Ayberk"},
    #                 {"vaccine": "asi1Ayberk"},
    #                 {"vaccine": "asi2Ayberk"},
    #                 {"vaccine": "asi3Ayberk"},
    #             ],
    #         },
    #         {
    #             "id": 1,
    #             "name": "Burcu",
    #             "surname": "Kose",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Burcu"},
    #                 {"vaccine": "asi1Burcu"},
    #                 {"vaccine": "asi2Burcu"},
    #                 {"vaccine": "asi3Burcu"},
    #             ],
    #         },
    #         {
    #             "id": 2,
    #             "name": "Ceyda",
    #             "surname": "Keskin",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Ceyda"},
    #                 {"vaccine": "asi1Ceyda"},
    #                 {"vaccine": "asi2Ceyda"},
    #                 {"vaccine": "asi3Ceyda"},
    #             ],
    #         },
    #         {
    #             "id": 3,
    #             "name": "Derya",
    #             "surname": "Dincer",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19"},
    #                 {"vaccine": "asi1"},
    #                 {"vaccine": "asi2"},
    #                 {"vaccine": "asi3"},
    #             ],
    #         },
    #         {
    #             "id": 3,
    #             "name": "Emre",
    #             "surname": "Demir",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Emre"},
    #                 {"vaccine": "asi1Emre"},
    #                 {"vaccineEmre": "asi2"},
    #                 {"vaccine": "asi3Emre"},
    #             ],
    #         },
    #         {
    #             "id": 3,
    #             "name": "Ferhat",
    #             "surname": "Koc",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Ferhat"},
    #                 {"vaccine": "asi1Ferhat"},
    #                 {"vaccine": "asi2Ferhat"},
    #                 {"vaccine": "asi3Ferhat"},
    #                 {"vaccine": "asi4Ferhat"},
    #             ],
    #         },
    #         {
    #             "id": 3,
    #             "name": "Gokhan",
    #             "surname": "Mutlu",
    #             "Age": 22,
    #             "withFriendsSince": "15.02.2021",
    #             "vaccines": [
    #                 {"vaccine": "covid19Gokhan"},
    #                 {"vaccine": "asi1Gokhan"},
    #                 {"vaccine": "asi2Gokhan"},
    #             ],
    #         },
    #     ]
    # }


@app.route("/user/codes", methods=["GET"])
def get_user_codes():
    user_id = request.args["user_id"]

    res = {"my_vaccines": get_user_all_vaccination_dicts(user_id)}

    return get_response(res, 200)

    # code_data = {
    #     "my_vaccines": [
    # {
    #     " ": 0,
    #     "name": "COVID-19",
    #     "date": "2021-3-3 15:12:06",
    #     "dose": 1,
    #     "vaccine_point": "Ankara Merkez",
    #     "valid_until": "2022-3-3 15:12:06",
    # },
    #         {
    #             "id": 0,
    #             "name": "COVID-19",
    #             "date": "15.02.2019",
    #             "dose": "1",
    #             "vaccine_point": "Ankara Merkez",
    #             "expires_in": "364",
    #         },
    #         {
    #             "id": 1,
    #             "name": "COVID-20",
    #             "date": "15.02.2020",
    #             "dose": "1",
    #             "vaccine_point": "Istranbul Merkez",
    #             "expires_in": "255",
    #         },
    #         {
    #             "id": 2,
    #             "name": "COVID-21",
    #             "date": "15.02.2021",
    #             "dose": "1",
    #             "vaccine_point": "Eskisehir Merkez",
    #             "expires_in": "321",
    #         },
    #         {
    #             "id": 3,
    #             "name": "COVID-22",
    #             "date": "15.02.2022",
    #             "dose": "1",
    #             "vaccine_point": "Adana Merkez",
    #             "expires_in": "0",
    #         },
    #     ]
    # }


@app.route("/friend-request", methods=["POST"])
def add_friend_request():
    user_id = request.json["user_id"]
    friend_id = request.json["friend_id"]
    dbops.add_friend_request(user_id, friend_id)

    return get_response({}, 200)


@app.route("/friend-requests", methods=["GET"])
def get_user_friend_requests():
    user_id = request.json["user_id"]
    res = {"friend_requests:": get_user_all_friend_request_dicts(user_id)}

    return get_response(res, 200)


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
    user_id = request.json["user_id"]
    new_privacy = request.json["new_privacy"]
    user = dbops.get_user(user_id)
    user.visilibty = new_privacy

    return get_response({}, 200)


@app.route("/get-privacy", methods=["GET"])
def get_vaccine_privacy():
    user_id = request.args["user_id"]
    user = dbops.get_user(user_id)
    res = {"privacy_setting": user.visibility}
    return get_response(res, 200)


@app.route("/create-link", methods=["POST"])
def create_link():
    user_id = request.json["user_id"]
    vaccination_ids = request.json["vaccination_ids"].copy()
    link = create_link_for_user(user_id, vaccination_ids)
    res = {"link": link}
    return get_response(res, 200)


@app.route("/get-vaccinations-from-link", methods=["GET"])
def get_vaccinations_from_link():
    link = request.args["link"]
    vaccination_ids = get_link_vaccination_ids(link)
    res = {"vaccinations": get_given_vaccination_dicts(vaccination_ids)}
    return get_response(res, 200)


if __name__ == "__main__":
    app.run()

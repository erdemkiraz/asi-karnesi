from hello import app
import dbops
import json

from flask import request, jsonify


def get_result(res, status):
    result = jsonify(res)
    result.status_code = status
    return result


@app.route("/add_user", methods=["POST"])
def add_user():
    name = request.json.get("name")
    country_id = request.json.get("country_id")
    dbops.add_user(name, country_id=country_id)
    return get_result({}, 200)


@app.route("/user", methods=["GET"])
def get_user():
    if "id" not in request.args:
        return get_result({"error": "No user id provided"}, 400)
    id = request.args["id"]
    user = dbops.get_user(id)
    if user is None:
        return get_result({"error": "User not found"}, 400)
    res = {
        "name": user.name,
        "country_id": user.country_id,
    }
    return get_result(res, 200)


@app.route("/basic_test")
def hello_world():
    dbops.add_country("turkeyq")
    turkey = dbops.get_country_by_name("turkeyq")
    print('id:', turkey)
    dbops.add_user("erdemsu", country_id=turkey.id)
    erdem = dbops.get_user_by_name("erdem")
    print(erdem.id, erdem)
    return "Hello Worldqqqasd!"


@app.route("/user/friends", methods=["GET"])
def get_user_friends():
    req = json.loads(request.data)
    req = req["data"]
    # return "asdas"
    print("Get users friend from db")
    print(req)

    # TODO:  data format is for test and can change, real data should come from DB. according to google_email
    #  parameter (this can be also changed) Further info => Ayberk
    
    friend_data = {
        "friends": [
            {"id": 0, "name": "Ayberk", "surname": "Uslu", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 1, "name": "Burcu", "surname": "Kose", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 2, "name": "Ceyda", "surname": "Keskin", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Derya", "surname": "Dincer", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Emre", "surname": "Demir", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Ferhat", "surname": "Koc", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Gokhan", "surname": "Mutlu", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines": [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
        ]
    }
    # Serializing json
    # json_object = json.dumps(data)
    # print(json_object)
    # print(jsonify(friend_data))
    return jsonify(friend_data)

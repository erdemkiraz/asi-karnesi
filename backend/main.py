from hello import app
import dbops
import json

from flask import request, jsonify, Flask
app = Flask(__name__)


def run():
    app.run()


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
    return set_response("Hello Worldqqqasd!")


@app.route("/user/friends", methods=["GET"])
def get_user_friends():
    # req = json.loads(request.data)
    # req = req["data"]
    # print(req)

    print("Get users friend from db")

    # TODO:  data format is for test and can change, real data should come from DB. according to google_email
    #  parameter (this can be also changed) Further info => Ayberk
    friend_data = {
        "friends": [
            {"id": 0, "name": "Ayberk", "surname": "Uslu", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 1, "name": "Burcu", "surname": "Kose", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 2, "name": "Ceyda", "surname": "Keskin", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Derya", "surname": "Dincer", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Emre", "surname": "Demir", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Ferhat", "surname": "Koc", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]},
            {"id": 3, "name": "Gokhan", "surname": "Mutlu", "Age": 22, "withFriendsSince": "15.02.2021",
             "vaccines":
                 [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]}
        ]
    }


    return set_response(friend_data)


@app.route("/add", methods=["POST"])
def add_new_friend():
    # req = json.loads(request.data)
    # req = req["data"]
    # print(req)
    print("Get users friend from db")

    # TODO:  data format is for test and can change, real data should come from DB. according to google_email
    #  parameter (this can be also changed) Further info => Ayberk

    return {"status": 200};
    # return jsonify(friend_data)

@app.route("/user/codes", methods=["GET"])
def get_user_codes():
    # req = json.loads(request.data)
    # req = req["data"]
    # print(req)

    # return "asdas"
    print("Get user codes  from db")

    # TODO:  data format is for test and can change, real data should come from DB. according to google_email
    #  parameter (this can be also changed) Further info => Ayberk

    code_data = {
        "my_vaccines": [
            {
                "id": 0,
                "name": "COVID-19",
                "date": "15.02.2019",
                "dose": "1",
                "vaccine_point": "Ankara Merkez",
                "expires_in": "364",
            },
            {
                "id": 1,
                "name": "COVID-20",
                "date": "15.02.2020",
                "dose": "1",
                "vaccine_point": "Istranbul Merkez",
                "expires_in": "255"
            },
            {
                "id": 2,
                "name": "COVID-21",
                "date": "15.02.2021",
                "dose": "1",
                "vaccine_point": "Eskisehir Merkez",
                "expires_in": "321"
            },
            {
                "id": 3,
                "name": "COVID-22",
                "date": "15.02.2022",
                "dose": "1",
                "vaccine_point": "Adana Merkez",
                "expires_in": "0"
            }
        ]
    }
    # Serializing json
    # json_object = json.dumps(code_data)
    # print(json_object)
    # print(jsonify(code_data))
    return set_response(code_data)


@app.route("/add-new-friend", methods=["POST"])
def add_new_friend():
    # req = json.loads(request.data)
    # req = req["data"]
    # print(req)

    print("Add new friendss")

    return set_response({"status": 200})
    # return jsonify(friend_data)


@app.route("/set-privacy", methods=["POST"])
def set_vaccine_privacy():
    print("Set vaccine privacy")

    return set_response({"status": 200})


@app.route("/get-privacy", methods=["GET"])
def get_vaccine_privacy():
    # req = json.loads(request.data)
    # req = req["data"]
    # print(req)
    vaccine_id = request.args.get('vaccine_id')
    print(vaccine_id)
    # 0 means Nobody should see his/her vaccine info . TODO: Calculate from db and send it to frontend!
    # Nobody : 0
    # Just Friends : 1
    # Everybody : 2
    vaccine_privacy_setting_from_db = "0"
    users_vaccine_privacy = {
        "privacy_setting": vaccine_privacy_setting_from_db
    }
    response = jsonify(users_vaccine_privacy)
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers',
                         'X-Requested-With, Content-Type, Accept, Origin, Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS')
    return set_response(users_vaccine_privacy)


    # return jsonify(users_vaccine_privacy)


def set_response(data):
    response = jsonify(data)
    response.headers.add('Access-Control-Allow-Origin', '*') ## needed for avoiding CORS policy
    response.headers.add('Access-Control-Allow-Headers',
                         'X-Requested-With, Content-Type, Accept, Origin, Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS')
    return response

=======
if __name__ == "__main__":
    app.run()

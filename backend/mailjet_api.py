from mailjet_rest import Client

api_key = "a7961312c568a49d4c05a0a37a59d78d"
api_secret = "f945f15494b6d8720e7e59255960023d"
mailjet = Client(auth=(api_key, api_secret), version="v3.1")


def send_email(recipient, name, body):
    try:
        data = {
            "Messages": [
                {
                    "From": {
                        "Email": "hello@asi-karnesi.herokuapp.com",
                        "Name": "Asi Karnesi",
                    },
                    "To": [
                        {
                            "Email": recipient,
                            "Name": name,
                        }
                    ],
                    "Subject": "Signup to Asi Karnesi to check vaccination status of people!",
                    "TextPart": "My first Mailjet email",
                    "HTMLPart": body,
                    "CustomID": "AppGettingStartedTest",
                }
            ]
        }
        print(data)
        result = mailjet.send.create(data=data)
        print(result, result.status_code)
        return result.status_code == 200
    except Exception:
        return False

import os
from twilio.rest import Client

account_sid = "ACcf93ddc15d0b48c8049cc305d24e0cb9"
auth_token = os.environ.get("TWILIO_AUTH_TOKEN")
number = "+15597174563"
client = Client(account_sid, auth_token)


def send_sms(phone, message):
    try:
        message = client.messages.create(body=message, from_=number, to=phone)
    except Exception:
        return False
    return True

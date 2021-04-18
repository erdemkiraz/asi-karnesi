import time
import json

import dbops
from util import create_user
from models import Vaccination


def listen(pubsub):
    while True:
        message = pubsub.get_message()
        if message:
            handle_message(message)
            time.sleep(0.001)


def handle_message(message):
    data = message["data"]
    d = json.loads(data)
    print(json.dumps(d, indent=2))

    for vaccination in d.get("vaccinations", []):
        email = vaccination.get("email")
        vaccine_id = vaccination.get("vaccine_id")
        vaccinated_at = vaccination.get("vaccinated_at")
        date = vaccination.get("date")

        valid_until = vaccination.get("valid_until")
        visibility = vaccination.get("visibility")
        created = vaccination.get("created")
        if email:
            dbops.create_user_from_email(email)
            user = dbops.get_user_from_email(email)

            row = Vaccination(
                user_id=user.id,
                vaccine_id=vaccine_id,
                vaccinated_at=vaccinated_at,
                date=date,
                valid_until=valid_until,
                visibility=visibility,
                created=created,
            )

            dbops.session.add(row)
            dbops.session.commit()

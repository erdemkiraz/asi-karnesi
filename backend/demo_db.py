import datetime

import dbops
from enums import VaccinationVisibility
from models import (
    FriendRequest,
    User,
    Country,
    Admin,
    Friendship,
    Vaccination,
    VaccinationLink,
    VaccinationStatusRequest,
    LinkVaccinationPair,
    Vaccine,
)


def add(row):
    try:
        dbops.session.add(row)
        dbops.session.commit()
    except Exception as e:
        print(e)
        dbops.session.rollback()


def populate():
    add(Country(id=1, name="Turkey"))
    add(Country(id=2, name="USA"))
    add(Country(id=3, name="UK"))
    add(Country(id=4, name="Germany"))

    add(
        User(
            id=1,
            google_id="demo_google_id_1",
            email="erdem@email1.com",
            name="Erdem Democu",
            age=21,
            country_id=1,
        )
    )
    add(
        User(
            id=2,
            google_id="demo_google_id_2",
            email="basak@email2.com",
            name="Basak Democu",
            age=22,
            country_id=1,
        )
    )
    add(
        User(
            id=3,
            google_id="demo_google_id_3",
            email="murat@email3.com",
            name="Murat Democu",
            age=23,
            country_id=1,
        )
    )
    add(
        User(
            id=4,
            google_id="demo_google_id_4",
            email="ayberk@email4.com",
            name="Ayberk Democu",
            age=24,
            country_id=1,
        )
    )
    add(
        User(
            id=5,
            google_id="demo_google_id_5",
            email="adam@german.com",
            name="Adam German",
            age=35,
            country_id=4,
        )
    )

    add(Vaccine(id=1, name="Covid-19 Biontech", required_dose=2))
    add(Vaccine(id=2, name="Covid-19 Moderna", required_dose=2))
    add(Vaccine(id=3, name="Influenza"))
    add(Vaccine(id=4, name="Polio"))

    add(
        Vaccination(
            id=1,
            user_id=1,
            vaccine_id=1,
            vaccinated_at="Ankara",
            date=datetime.datetime(2021, 2, 3, 12),
            valid_until=datetime.datetime(2022, 2, 3, 12),
            visibility=VaccinationVisibility.PUBLIC.value,
        )
    )
    add(
        Vaccination(
            id=2,
            user_id=2,
            vaccine_id=1,
            vaccinated_at="Ankara",
            date=datetime.datetime(2021, 2, 22, 4),
            valid_until=datetime.datetime(2022, 2, 22, 4),
            visibility=VaccinationVisibility.PUBLIC.value,
        )
    )

    add(Friendship(id=1, user_id1=1, user_id2=2, is_facebook=True))
    pass

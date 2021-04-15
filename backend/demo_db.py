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
    add(
        User(
            id=6,
            google_id="115512136232290362553",
            email="usluayberk1998@gmail.com",
            name="Ayberk Uslu",
            age=22,
            country_id=1,
        )
    )
    add(
        User(
            id=7,
            google_id="118071647661695719427",
            email="erdemkiraz@gmail.com",
            name="Erdem Kirez",
            age=22,
            country_id=1,
        )
    )
    add(
        User(
            id=8,
            google_id="114491661639251135156",
            email="korilipokybird@gmail.com",
            name="Korili Pokybird",
            age=19,
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
    add(
        Vaccination(
            id=3,
            user_id=6,
            vaccine_id=1,
            vaccinated_at="Ankara",
            date=datetime.datetime(2021, 1, 3, 17),
            valid_until=datetime.datetime(2022, 1, 3, 17),
            visibility=VaccinationVisibility.PUBLIC.value,
        )
    )
    add(
        Vaccination(
            id=4,
            user_id=7,
            vaccine_id=1,
            vaccinated_at="Istanbul",
            date=datetime.datetime(2021, 2, 3, 17),
            valid_until=datetime.datetime(2022, 2, 3, 17),
            visibility=VaccinationVisibility.PUBLIC.value,
        )
    )
    add(
        Vaccination(
            id=5,
            user_id=8,
            vaccine_id=2,
            vaccinated_at="Konya",
            date=datetime.datetime(2021, 3, 4, 17),
            valid_until=datetime.datetime(2022, 3, 4, 17),
            visibility=VaccinationVisibility.PUBLIC.value,
        )
    )


    add(Friendship(id=1, user_id1=1, user_id2=2, is_facebook=True))
    add(Friendship(id=2, user_id1=2, user_id2=1, is_facebook=True))
    add(Friendship(id=3, user_id1=6, user_id2=7, is_facebook=True))
    add(Friendship(id=4, user_id1=7, user_id2=6, is_facebook=True))
    add(Friendship(id=5, user_id1=6, user_id2=8, is_facebook=True))
    add(Friendship(id=6, user_id1=8, user_id2=6, is_facebook=True))

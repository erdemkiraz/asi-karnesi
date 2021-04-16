import datetime
import random
from string import digits

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

START = 1000000

ID_ATTRS = [
    "id",
    "country_id",
    "vaccine_id",
    "requester_id",
    "requestee_id",
    "user_id",
    "link_id",
    "user_id1",
    "user_id2",
]


names = [
    "Queenie Prude",
    "Kaylene Ruth",
    "Robbie Drumm",
    "Rosella Bailey",
    "Maia Heidelberg",
    "Hisako Pickney",
    "Von Koelling",
    "Willa Fancher",
    "Larisa Krantz",
    "Elsy Deere",
    "Summer Mckee",
    "Sophia Sansone",
    "Dell Kress",
    "Ellyn Marrow",
    "Maudie Vickers",
    "Natasha Callejas",
    "Jeannetta Mcbain",
    "Oma Gascon",
    "Huey Coughlin",
    "Galen Callery",
    "Jodi Castor",
    "Houston Null",
    "Wanita Peredo",
    "Chanell Dejesus",
    "Rachell Giorgio",
    "Neville Losey",
    "Betsy Mcsorley",
    "Yesenia Lachance",
    "Ellena Feingold",
    "Shawnee Fraga",
    "Elden Anglin",
    "Heide Giblin",
    "Caron Poage",
    "Ryan Entrekin",
    "Geneva Buchanon",
    "Marvel Howes",
    "Pei Wallander",
    "Joane Klahn",
    "Keisha Daye",
    "Cinthia Mead",
    "Marg Buzard",
    "Lynelle Hudspeth",
    "Aracelis Ettinger",
    "Wallace Wixom",
    "Isreal Chong",
    "Annette Gurley",
    "Sunni Sternberg",
    "Malik Tamayo",
    "Mireille Crozier",
    "Simon Levert",
]
emails = [
    "f6dd6fdar39jccs@charter.org",
    "zwob@verizon.gov",
    "otcdu@outlook.com",
    "9ecjd13s@hotmail.org",
    "juznq4m3c26kr@hotmail.com",
    "q@frontier.org",
    "a@charter.gov",
    "yvql@comcast.net",
    "n@comcast.com",
    "84oce@outlook.org",
    "6dx@yahoo.gov",
    "q@gmail.org",
    "38p@frontier.org",
    "a7s3kxhjg5k@verizon.com",
    "rz31ywn1x@verizon.com",
    "0ydl1fx4vul2vyyz@frontier.org",
    "q6xlm9z5d@charter.net",
    "i9c@outlook.gov",
    "b@frontier.org",
    "b4xsbhu1fp9n@outlook.net",
    "epku9hupa3k4bcm97iz@yahoo.org",
    "3a4aji5xjq7g0aas2@charter.net",
    "tqkf8rk5181qug@charter.net",
    "621nkwmp2e7gl@yahoo.org",
    "dzysp13exoiebbar682d@yahoo.gov",
    "nw1wbqcu76dthjdun53q@charter.gov",
    "oik4yqx9@charter.com",
    "sqeqo284n6fkmclg@charter.org",
    "zwdrs7o8gnjln@hotmail.net",
    "sd3qt2bag2r5nh4gbr@frontier.com",
    "cjiiu55om@yahoo.org",
    "82yh54oyc85w7uj1@outlook.com",
    "fe5kb6df@outlook.gov",
    "tij6x2moppx@hotmail.com",
    "smqs0xs12uu3488gowl@yahoo.gov",
    "gsye8za@frontier.org",
    "l@hotmail.gov",
    "qk5tl@comcast.gov",
    "swwoy3l@charter.gov",
    "7ky45o7g0av9fl5myu@yahoo.gov",
    "iqy@hotmail.com",
    "ei@comcast.gov",
    "2093b3sa3ht0v7odo@charter.gov",
    "2f2onyjp@frontier.org",
    "ixca1tc@gmail.gov",
    "zkbyi43gjzzov@comcast.org",
    "hihm@gmail.com",
    "s4aizigu0qyq3apz08n@verizon.org",
    "adc0k31nbk@hotmail.com",
    "07bsbo7xujk85u@yahoo.org"
]
countries = [
    "Turkey",
    "USA",
    "UK",
    "Germany",
    "Finland",
    "Denmark",
    "Switzerland",
    "Iceland",
]
def add(row):
    for attr in dir(row):
        if attr in ID_ATTRS:
            cur = getattr(row, attr)
            if cur is not None:
                setattr(row, attr, cur + START)
    print("New Row:")
    print(row.__dict__)

    try:
        dbops.session.add(row)
        dbops.session.commit()
    except Exception as e:
        print(e)
        dbops.session.rollback()


def populate():

    print(len(names))
    print(len(emails))
    print(len(countries))

    for i in range(len(countries)):
        print(i+1, countries[i])
        add(Country(id=i+1, name=countries[i]))

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

    for i in range(len(names)):
        id = i+6
        email = emails[i]
        name = names[i]
        country_id = random.randint(1, len(countries))
        age = random.randint(15, 65)
        google_id = ''.join(random.choice(digits) for i in range(21))
        print(id, email, name, country_id, age, google_id)
        add(
            User(
                id=id,
                google_id=google_id,
                email=email,
                name=name,
                age=age,
                country_id=country_id,
            )
        )


    add(Vaccine(id=1, name="Covid-19 Biontech", required_dose=2))
    add(Vaccine(id=2, name="Covid-19 Moderna", required_dose=2))
    add(Vaccine(id=3, name="Influenza"))
    add(Vaccine(id=4, name="Polio"))
    add(Vaccine(id=5, name="Diphtheria"))
    add(Vaccine(id=6, name="Tetanus"))
    add(Vaccine(id=7, name="Pertussis"))
    add(Vaccine(id=8, name="Poliomyelitis"))
    add(Vaccine(id=9, name="Measles"))
    add(Vaccine(id=10, name="Rubella"))



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

    vaccination_points = [
        "Ankara",
        "Istanbul",
        "London",
        "New York",
        "Paris",
        "Munich"
    ]

    vaccination_id = 2
    for user_id in range(6, len(names)+6):
        for vaccine_id in range(1, 11):
            if random.randint(1, 10) < 7:
                vaccination_id += 1
                vaccinated_at = vaccination_points[random.randint(0, len(vaccination_points)-1)]
                date = datetime.datetime(2020, random.randint(1, 12), random.randint(1, 28),
                                         random.randint(8, 18), random.randint(0, 59), random.randint(0, 59))
                valid_until = datetime.datetime(2020, random.randint(1, 12), random.randint(1, 28),
                                                random.randint(8, 18), random.randint(0, 59), random.randint(0, 59))
                visibility = VaccinationVisibility.PUBLIC.value
                add(
                    Vaccination(
                        id=vaccination_id,
                        user_id=user_id,
                        vaccine_id=vaccine_id,
                        vaccinated_at=vaccinated_at,
                        date=date,
                        valid_until=valid_until,
                        visibility=visibility,
                    )
                )
                print(vaccination_id, user_id, vaccine_id, vaccinated_at, date, valid_until, visibility)

    add(Friendship(id=1, user_id1=1, user_id2=2, is_facebook=True))
    add(Friendship(id=2, user_id1=2, user_id2=1, is_facebook=True))
    add(Friendship(id=3, user_id1=6, user_id2=7, is_facebook=True))
    add(Friendship(id=4, user_id1=7, user_id2=6, is_facebook=True))
    add(Friendship(id=5, user_id1=6, user_id2=8, is_facebook=True))
    add(Friendship(id=6, user_id1=8, user_id2=6, is_facebook=True))

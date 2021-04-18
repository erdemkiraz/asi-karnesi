import dbops
import random
import string

from enums import VaccinationVisibility


def can_see_vaccines(user_id, target_user_id, vaccination_id):
    vaccination = dbops.get_vaccination(vaccination_id)
    visibility = vaccination.visibility

    if visibility == VaccinationVisibility.PUBLIC.value:
        return True

    if visibility >= VaccinationVisibility.ALL_ADMINS.value:
        is_user_admin = dbops.get_admin_from_user_safe(user_id) is not None
        if is_user_admin:
            return True

    if visibility >= VaccinationVisibility.PERMITTED_USERS.value:
        if dbops.has_granted_vaccination_request(user_id, target_user_id):
            return True

    if visibility >= VaccinationVisibility.FRIENDS.value:
        if dbops.is_friend(user_id, target_user_id):
            return True

    if visibility >= VaccinationVisibility.FACEBOOK_FRIENDS.value:
        if dbops.is_facebook_friend(user_id, target_user_id):
            return True

    return False


def get_datetime_str(dt):
    """
    >>> dt = datetime.datetime.now()
    >>> def get_datetime_str(dt):
    ...     return dt.strftime("%Y-%m-%d %H:%M:%S")
    >>> get_datetime_str(dt)
    '2021-04-11 17:19:10'
    """
    return dt.strftime("%Y-%m-%d %H:%M:%S")


def get_vaccination_dict(vaccination):
    vaccine = dbops.get_vaccine(vaccination.vaccine_id)
    res = {
        "vaccination_id": vaccination.id,
        "vaccine_id": vaccination.vaccine_id,
        "name": vaccine.name,
        "date": get_datetime_str(vaccination.date) if vaccination.date else "",
        "dose": 1,  # this info shouldn't be here
        "vaccine_point": vaccination.vaccinated_at,
        "valid_until": get_datetime_str(vaccination.valid_until)
        if vaccination.valid_until
        else "",
    }
    return res


def get_user_all_vaccination_dicts(user_id):
    vaccinations = dbops.get_user_vaccinations(user_id)
    vaccination_dicts = [get_vaccination_dict(x) for x in vaccinations]
    return vaccination_dicts


def get_given_vaccination_dicts(vaccination_ids):
    vaccination_dicts = []
    for vaccination_id in vaccination_ids:
        vaccination = dbops.get_vaccination(vaccination_id)
        vaccination_dicts.append(get_vaccination_dict(vaccination))
    return vaccination_dicts


def get_user_dict(user_id):
    user = dbops.get_user(user_id)
    vaccination_dicts = get_user_all_vaccination_dicts(user.id)
    res = {
        "id": user.id,
        "google_id": user.google_id,
        "name": user.name or "",
        "age": user.age,
        "country_name": dbops.get_country_name(user.country_id) or "",
        "vaccines": vaccination_dicts,
    }
    return res


def get_friend_request_dict(friend_request):
    requester_user = dbops.get_user(friend_request.requester_id)
    res = {
        "request_id": friend_request.id,
        "requester_id": requester_user.id,
        "requester_email": requester_user.email,
        "requester_name": requester_user.name,
        "created": get_datetime_str(friend_request.created)
        if friend_request.created
        else "",
    }
    return res


def get_user_all_friend_request_dicts(user_id):
    friend_requests = dbops.get_active_friend_requests_to_user(user_id)
    friend_request_dicts = [
        get_friend_request_dict(friend_request) for friend_request in friend_requests
    ]
    return friend_request_dicts


def update_friend_request(request_id, accept):
    if accept:
        friend_request = dbops.get_friend_request(request_id)
        dbops.add_friend(friend_request.requester_id, friend_request.requestee_id)
    dbops.delete_friend_request(request_id)


def get_friend_dict(user_id, friend_id):
    friendship = dbops.get_friendship(user_id, friend_id)
    friend_dict = get_user_dict(friend_id)

    friend_dict["vaccines"] = [
        vaccination_dict
        for vaccination_dict in friend_dict["vaccines"]
        if can_see_vaccines(user_id, friend_id, vaccination_dict["vaccination_id"])
    ]

    friend_dict["with_friends_since"] = (
        get_datetime_str(friendship.created) if friendship.created else ""
    )

    return friend_dict


def get_user_all_friend_dicts(user_id):
    friend_ids = dbops.get_friend_ids(user_id)
    # print(f'{friend_ids=}')
    friend_dicts = [get_friend_dict(user_id, friend_id) for friend_id in friend_ids]
    return friend_dicts


def get_random_string(length):
    link = ""
    while True:
        link = "".join(
            random.choice(string.ascii_letters + string.digits) for i in range(length)
        )
        if dbops.get_vaccination_link_from_link(link) is None:
            break
    return link


def create_link_for_user(user_id, vaccination_ids):
    link = get_random_string(40)
    dbops.add_vaccination_link(user_id=user_id, link=link)
    vaccination_link_row = dbops.get_vaccination_link_from_link(link)
    assert vaccination_link_row is not None
    link_id = vaccination_link_row.id
    for vaccination_id in vaccination_ids:
        dbops.add_link_vaccination_pair(link_id=link_id, vaccination_id=vaccination_id)
    return link


def get_link_vaccination_ids(link):
    vaccination_link_row = dbops.get_vaccination_link_from_link(link)
    if vaccination_link_row is None:
        return []
    link_id = vaccination_link_row.id
    vaccination_ids = dbops.get_vaccination_ids_from_link_id(link_id)
    return vaccination_ids

def create_user(google_id, email):
    user = dbops.get_user_from_google_id(google_id)
    if user is not None:
        return False

    if email is not None:
        user = dbops.get_user_from_email(email)
        if user is not None:
            user.google_id = google_id
            dbops.session.commit()
            return False

    dbops.create_user(google_id)
    return True


def pretty_name(name):
    if not name:
        return None
    name = "".join([c for c in name if c.isalpha() or c in ".()[] "])
    names = name.strip().split()
    if len(names) > 4:
        return None
    for name in names:
        if len(name) > 15:
            return None

    def capitalize(name):
        if name[0].isalpha():
            return name.lower().capitalize()
        return name

    name = " ".join([capitalize(name) for name in names])
    return name


def get_countries_list():
    countries = dbops.get_all_country_list()
    data = []
    for country in countries:
        data.append({"id": country.id, "name": country.name})
    return data


def get_vaccines_list():
    vaccines = dbops.get_all_vaccines_list()
    data = []
    for vaccine in vaccines:
        data.append({"id": vaccine.id, "name": vaccine.name})
    return data


def get_vaccine_statistics_list(country_id, vaccine, age_from, age_to):
    vaccination_dates = dbops.get_vaccination_dates(
        country_id, vaccine, age_from, age_to
    )
    # vaccination_dates = [get_vaccination_date(vaccination_id) for vaccination_id in vaccination_ids]
    vaccination_dates.sort()
    months = [
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
    ]
    # counts = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    data = [0 for _ in range(12)]
    for vaccination_date in vaccination_dates:
        data[(vaccination_date.month + 7) % 12] += 1

    for i in range(len(data)):
        if i > 0:
            data[i] += data[i - 1]

    data = [{"month": months[i], "total": data[i]} for i in range(len(months))]

    return data

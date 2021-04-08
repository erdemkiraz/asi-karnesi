import dbops
import random
import string

from enums import UserVisibility


def can_see_vaccines(user_id, target_user_id):
    visibility = dbops.get_user_visibility(target_user_id)

    if visibility == UserVisibility.PUBLIC.value:
        return True

    if visibility >= UserVisibility.ALL_ADMINS.value:
        is_user_admin = dbops.get_admin_from_user_safe(user_id) is not None
        if is_user_admin:
            return True

    if visibility >= UserVisibility.PERMITTED_USER.value:
        if dbops.has_granted_vaccination_request(user_id, target_user_id):
            return True

    if visibility >= UserVisibility.FRIENDS.value:
        if dbops.is_friend(user_id, target_user_id):
            return True

    return False


def get_vaccination_dict(vaccination):
    vaccine = dbops.get_vaccine(vaccination.vaccine_id)
    res = {
        "vaccination_id": vaccination.id,
        "vaccine_id": vaccination.vaccine_id,
        "name": vaccine.name,
        "date": vaccination.date,
        "dose": 1,  # this info shouldn't be here
        "vaccine_point": vaccination.vaccinated_at,
        "valid_until": vaccination.valid_until,
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
    res = {
        "id": user.id,
        "name": user.name,
        "email": user.email,
    }
    return res


def get_vaccine_dict(vaccine_id):
    vaccine = dbops.get_vaccine(vaccine_id)
    res = {
        "id": vaccine.id,
        "name": vaccine.name,
        "required_dose": vaccine.required_dose,
    }
    return res


def get_friend_request_dict(friend_request):
    requestee_user = dbops.get_user(friend_request.requestee_id)
    res = {
        "request_id": friend_request.id,
        "requester_id": requestee_user.id,
        "requester_email": "requestee_user.email",
        "requester_name": requestee_user.name,
        "created": friend_request.created,
    }
    return res


def get_user_all_friend_request_dicts(user_id):
    friend_requests = dbops.get_active_friend_requests_to_user(user_id)
    friend_request_dicts = [
        get_friend_request_dict(friend_request) for friend_request in friend_requests
    ]
    return friend_request_dicts


def accept_friend_request(request_id):
    friend_request = dbops.get_friend_request(request_id)
    dbops.add_friend(friend_request.requester.id, friend_request.requestee_id)
    dbops.delete_friend_request(request_id)


def reject_friend_request(request_id):
    dbops.delete_friend_request(request_id)


def get_friend_dict(user_id, friend_id):
    friendship = dbops.get_friendship(user_id, friend_id)
    friend_dict = get_user_dict(friend_id)

    if not can_see_vaccines(user_id, friend_id):
        friend_dict["vaccines"] = []

    friend_dict["with_friends_since"] = friendship.created

    return friend_dict


def get_user_all_friend_dicts(user_id):
    friend_ids = dbops.get_friend_ids(user_id)
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

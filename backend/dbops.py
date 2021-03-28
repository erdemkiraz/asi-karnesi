from backend.dbconf import session
from backend.models import (
    FriendRequest,
    User,
    Country,
    Admin,
    Friendship,
    Vaccination,
    VaccinationStatusRequest,
    Vaccine,
)


def add_user(name, *, country_id=None, visibility=None):
    user = User(name=name, country_id=country_id, visibility=visibility)
    session.add(user)
    session.commit()


def get_user(user_id):
    query = session.query(User).filter(User.id == user_id)
    user = query.one_or_none()
    return user


def get_user_by_name(name):
    query = session.query(User).filter(User.name.like("%" + name + "%"))
    return query.first()


def remove_user(user_id):
    session.query(User).filter(User.id == user_id).delete()


def add_country(name):
    country = Country(name=name)
    session.add(country)
    session.commit()


def get_country_by_name(name):
    query = session.query(Country).filter(Country.name.like("%" + name + "%"))
    return query.first()


def add_friend(user_id1, user_id2):
    row1 = Friendship(user_id1=user_id1, user_id2=user_id2)
    row2 = Friendship(user_id1=user_id2, user_id2=user_id1)
    session.add(row1)
    session.add(row2)
    session.commit()


def add_friend_request(user_id1, user_id2):
    row = FriendRequest(requester_id=user_id1, requestee_id=user_id2)
    session.add(row)
    session.commit()

def delete_friend_request(request_id):
    session.query(FriendRequest).filter(request_id).delete()
    session.commit()


def get_active_friend_requests_to_user(user_id):
    query = session.query(FriendRequest).filter(FriendRequest.requestee_id == user_id)
    return query.all()


def get_friend_request(request_id):
    query = session.query(FriendRequest).filter(FriendRequest.id == request_id)
    return query.first()


def is_friend(user_id1, user_id2):
    query = session.query(Friendship).filter(
        Friendship.user_id1 == user_id1, Friendship.user_id2 == user_id2
    )
    return query.first() is not None


def get_admin_from_user_safe(user_id):
    query = session.query(Admin).filter(Admin.user_id == user_id)
    return query.first()


def has_granted_vaccination_request(requester_id, requestee_id):
    query = session.query(VaccinationStatusRequest).filter(
        VaccinationStatusRequest.requester_id == requester_id,
        VaccinationStatusRequest.requestee_id == requestee_id,
    )
    status = query.first()
    return status is not None and status.has_granted


def get_friend_ids(user_id):
    query = session.query(Friendship.user_id2).filter(Friendship.user_id1 == user_id)
    friends = query.all()
    friend_ids = [x[0] for x in friends]
    return friend_ids


def get_user_vaccinations(user_id):
    query = session.query(Vaccination).filter(Vaccination.user_id == user_id)
    vaccinations = query.all()
    return vaccinations


def get_vaccine(vaccine_id):
    query = session.query(Vaccine).filter(Vaccine.id == vaccine_id)
    return query.one_or_none()

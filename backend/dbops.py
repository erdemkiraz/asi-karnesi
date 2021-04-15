from dbconf import session
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


def get_user(user_id):
    query = session.query(User).filter(User.id == user_id)
    user = query.one_or_none()
    return user


def get_user_from_google_id(google_id):
    query = session.query(User).filter(User.google_id == google_id)
    user = query.one_or_none()
    return user


def get_user_from_email(email):
    query = session.query(User).filter(User.email == email)
    user = query.one_or_none()
    return user


def create_user(google_id):
    user = User(google_id=google_id)
    session.add(user)
    session.commit()


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


def get_friendship(user_id, friend_id):
    query = session.query(Friendship).filter(
        Friendship.user_id1 == user_id, Friendship.user_id2 == friend_id
    )
    return query.first()


def add_facebook_friend(user_id1, user_id2):
    row1 = Friendship(user_id1=user_id1, user_id2=user_id2, is_facebook=True)
    row2 = Friendship(user_id1=user_id2, user_id2=user_id1, is_facebook=True)
    session.add(row1)
    session.add(row2)
    session.commit()


def add_friend_request(user_id1, user_id2):
    row = FriendRequest(requester_id=user_id1, requestee_id=user_id2)
    session.add(row)
    session.commit()


def delete_friend_request(request_id):
    session.query(FriendRequest).filter(FriendRequest.id == request_id).delete()
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


def is_facebook_friend(user_id1, user_id2):
    query = session.query(Friendship).filter(
        Friendship.user_id1 == user_id1, Friendship.user_id2 == user_id2
    )
    friendship = query.first()
    return friendship is not None and friendship.is_facebook


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


def get_vaccination(vaccination_id):
    query = session.query(Vaccination).filter(Vaccination.id == vaccination_id)
    return query.one()


def get_vaccine(vaccine_id):
    query = session.query(Vaccine).filter(Vaccine.id == vaccine_id)
    return query.one_or_none()


def get_vaccination_link(vaccination_link_id):
    query = session.query(VaccinationLink).filter(
        VaccinationLink.id == vaccination_link_id
    )
    return query.one_or_none()


def get_vaccination_link_from_link(link):
    query = session.query(VaccinationLink).filter(VaccinationLink.link == link)
    return query.first()


def add_vaccination_link(user_id, link):
    vaccination_link = VaccinationLink(user_id=user_id, link=link)
    session.add(vaccination_link)
    session.commit()


def add_link_vaccination_pair(link_id, vaccination_id):
    link_vaccination_pair = LinkVaccinationPair(
        link_id=link_id, vaccination_id=vaccination_id
    )
    session.add(link_vaccination_pair)
    session.commit()


def get_vaccination_ids_from_link_id(link_id):
    query = session.query(LinkVaccinationPair.vaccination_id).filter(
        LinkVaccinationPair.link_id == link_id
    )
    vaccination_ids = [x[0] for x in query.all()]
    return vaccination_ids


def get_country_name(country_id):
    if country_id is None:
        return None
    query = session.query(Country).filter(Country.id == country_id)
    country = query.first()
    return country.name


def add_user_google_token(user_id, token):
    query = session.query(User).filter(User.id == user_id)
    user = query.one()
    user.google_token = token

    session.commit()


def get_user_google_token(user_id):
    query = session.query(User).filter(User.id == user_id)
    user = query.one()
    return user.google_token

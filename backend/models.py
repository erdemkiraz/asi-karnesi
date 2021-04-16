import datetime
from sqlalchemy.sql.sqltypes import Boolean, DateTime, JSON
from sqlalchemy import Column, Integer, String, ForeignKey

from conf import Base, engine
from enums import VaccinationVisibility, AdminPrivilege


class User(Base):
    __tablename__ = "user"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    google_id = Column(String, unique=True, nullable=False)
    facebook_id = Column(String, unique=True, nullable=True)
    google_token = Column(JSON)
    email = Column(String, unique=True)
    name = Column(String)
    age = Column(Integer)
    country_id = Column(Integer, ForeignKey("country.id"))

    def __repr__(self):
        return "<User(name='%s')>" % (self.name)


class Country(Base):
    __tablename__ = "country"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    name = Column(String)

    def __repr__(self):
        return "<Country(name='%s')>" % (self.name)


class Vaccine(Base):
    __tablename__ = "vaccine"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    required_dose = Column(Integer, default=1)


class Vaccination(Base):
    __tablename__ = "vaccination"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"))
    vaccine_id = Column(Integer, ForeignKey("vaccine.id"))
    vaccinated_at = Column(String)
    date = Column(DateTime, default=datetime.datetime.now)
    valid_until = Column(DateTime, default=datetime.datetime.now)
    visibility = Column(Integer, default=VaccinationVisibility.PRIVATE.value)


class VaccinationStatusRequest(Base):
    __tablename__ = "vaccination_status_request"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    requester_id = Column(Integer, ForeignKey("user.id"))
    requestee_id = Column(Integer, ForeignKey("user.id"))
    has_granted = Column(Boolean, default=False)


class VaccinationLink(Base):
    __tablename__ = "vaccination_link"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"))
    link = Column(String, nullable=False)


class LinkVaccinationPair(Base):
    __tablename__ = "link_vaccination_pair"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    link_id = Column(Integer, ForeignKey("vaccination_link.id"))
    vaccination_id = Column(Integer, ForeignKey("vaccination.id"))


class FriendRequest(Base):
    __tablename__ = "friend_request"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    requester_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    requestee_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    created = Column(DateTime, default=datetime.datetime.now)


class Friendship(Base):
    __tablename__ = "friendship"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id1 = Column(Integer, ForeignKey("user.id"), nullable=False)
    user_id2 = Column(Integer, ForeignKey("user.id"), nullable=False)
    is_facebook = Column(Boolean, default=False)
    created = Column(DateTime, default=datetime.datetime.now)


class Admin(Base):
    __tablename__ = "admin"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    privilege = Column(Integer, default=AdminPrivilege.ONLY_SAME_COUNTRY.value)


Base.metadata.create_all(engine)

import datetime
from sqlalchemy.sql.sqltypes import Boolean, DateTime
from sqlalchemy import Column, Integer, String, ForeignKey

from backend.dbconf import Base, engine
from backend.util import UserVisibility, AdminPrivilege


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    age = Column(Integer)
    country_id = Column(Integer, ForeignKey("country.id"))
    visibility = Column(Integer, default=UserVisibility.PRIVATE.value)

    def __repr__(self):
        return "<User(name='%s')>" % (self.name)


class Country(Base):
    __tablename__ = "country"

    id = Column(Integer, primary_key=True)
    name = Column(String)

    def __repr__(self):
        return "<Country(name='%s')>" % (self.name)


class Vaccine(Base):
    __tablename__ = "vaccine"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    required_dose = Column(Integer)


class Vaccination(Base):
    __tablename__ = "vaccination"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"))
    vaccine_id = Column(Integer, ForeignKey("vaccine.id"))
    vaccinated_at = Column(String)
    date = Column(DateTime, default=datetime.datetime.now)
    valid_until = date = Column(DateTime, default=datetime.datetime.now)


class VaccinationStatusRequest(Base):
    __tablename__ = "vaccination_status_request"

    id = Column(Integer, primary_key=True)
    requested_id = Column(Integer, ForeignKey("user.id"))
    requestee_id = Column(Integer, ForeignKey("user.id"))
    has_granted = Column(Boolean, default=False)


class FriendRequest(Base):
    __tablename__ = "friend_request"
    id = Column(Integer, primary_key=True)
    requester_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    requestee_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    created = Column(DateTime, default=datetime.datetime.now)


class Friendship(Base):
    __tablename__ = "friendship"
    id = Column(Integer, primary_key=True)
    user_id1 = Column(Integer, ForeignKey("user.id"), nullable=False)
    user_id2 = Column(Integer, ForeignKey("user.id"), nullable=False)
    created = Column(DateTime, default=datetime.datetime.now)


class Admin(Base):
    __tablename__ = "admin"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    privilege = Column(Integer, default=AdminPrivilege.BASIC.value)


Base.metadata.create_all(engine)

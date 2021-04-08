import datetime
from sqlalchemy.sql.sqltypes import Boolean, DateTime
from sqlalchemy import Column, Integer, String, ForeignKey

from dbconf import Base, engine
from enums import UserVisibility, AdminPrivilege


class User(Base):
    __tablename__ = "user"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    name = Column(String)
    country_id = Column(Integer, ForeignKey("country.id"))
    visibility = Column(Integer, default=UserVisibility.PRIVATE.value)
    email = Column(String)
    #google_id = Column(String)

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
    required_dose = Column(Integer)


class Vaccination(Base):
    __tablename__ = "vaccination"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"))
    vaccine_id = Column(Integer, ForeignKey("vaccine.id"))
    vaccinated_at = Column(String)
    date = Column(DateTime, default=datetime.datetime.now)
    valid_until = date = Column(DateTime, default=datetime.datetime.now)


class VaccinationStatusRequest(Base):
    __tablename__ = "vaccination_status_request"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    requested_id = Column(Integer, ForeignKey("user.id"))
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
    created = Column(DateTime, default=datetime.datetime.now)


class Admin(Base):
    __tablename__ = "admin"
    __table_args__ = {"extend_existing": True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    privilege = Column(Integer, default=AdminPrivilege.ONLY_SAME_COUNTRY.value)


Base.metadata.create_all(engine)

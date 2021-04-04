from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

engine = create_engine(
    "sqlite:///database.db", echo=True, connect_args={"check_same_thread": False}
)

Session = sessionmaker(bind=engine)
session = Session()

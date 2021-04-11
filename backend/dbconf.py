from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

Base = declarative_base()

local_db_url = "sqlite:///database.db"
db_url = os.environ.get("POSTGRE_DATABASE_URL", local_db_url)

engine = create_engine(
    db_url,
    echo=True,  # connect_args={"check_same_thread": False}
)

Session = sessionmaker(bind=engine)
session = Session()

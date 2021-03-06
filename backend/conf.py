from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

Base = declarative_base()

local_db_url = "sqlite:///database.db"
postgre_url = os.environ.get("POSTGRE_DATABASE_URL")

is_production = bool(postgre_url)

db_url = postgre_url or local_db_url

if is_production:
    engine = create_engine(db_url, echo=True)
else:
    engine = create_engine(db_url, echo=True, connect_args={"check_same_thread": False})

Session = sessionmaker(bind=engine)
session = Session()

filename = "secrets.txt"
try:
    with open(filename, mode="rb") as config_file:
        for line in config_file.readlines():
            # print("Line: XXX" + line.decode("utf-8").strip() + "XXX")
            key, *values = line.decode("utf-8").strip().split("=")
            value = "=".join(values)
            os.environ[key] = value
            # print(key, ' --> ', value)
except IOError as e:
    print("Unable to load configuration file (%s)" % e.strerror)
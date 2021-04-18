from flask import Flask
from flask_cors import CORS
from flask_redis import FlaskRedis

app = Flask(__name__)

redis_client = FlaskRedis(app)
pubsub = redis_client.pubsub(ignore_subscribe_messages=True)

pubsub.subscribe("asi-karnesi")


def listen_pubsub():
    import distributed

    distributed.listen(pubsub)


import threading

listener_thread = threading.Thread(target=listen_pubsub, name="Listener")
listener_thread.start()

CORS(app)


def run():
    pass


if __name__ == "hello":
    run()

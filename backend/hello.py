from flask import Flask
from flask_cors import CORS
app = Flask(__name__)

CORS(app)

def run():
    app.run()


if __name__ == "__main__":
    run()

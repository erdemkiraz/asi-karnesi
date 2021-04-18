export FLASK_APP=main.py
# export FLASK_ENV=development
lsof -ti:5000 | xargs kill -9

flask run
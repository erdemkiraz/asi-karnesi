# asi-karnesi
[![Heroku](https://heroku-badge.herokuapp.com/?app=asi-karnesi)]

International vaccine passport that can be easily ported

## Backend

Flask: https://flask.palletsprojects.com/en/1.1.x/quickstart/

First run:

Install flask, sqlite, slqalchemy

Local development:

```
cd backend
./run.sh
```

It should be accessible it at http://127.0.0.1:5000/

You can change the code and it'll be live instantly. You don't need to start it again.

## Database

SQLite is used for database. All the contect is inside `database.db`.

SQLAlchemy: https://docs.sqlalchemy.org/en/13/orm/tutorial.html

If you change the attributes of an **already existing** table, you should delete `database.db` and we should start over. It'll be created on it's own and you don't have to create it again, but we'll lose all the existing data. We should start using Alembic (https://alembic.sqlalchemy.org/en/latest/index.html) to migrate properly.

## Development

```
git checkout -b your-branch

# ... (change code)
git add .
git commit -m "commit description"

git fetch # fetch updates from remote
git rebase origin/master # use rebase for better commit history
git push
```

## Testing

Check an existing user with user id.

http://127.0.0.1:5000/user?id=2

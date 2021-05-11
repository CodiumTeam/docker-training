#!/usr/bin/env python
import os, logging

from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)

client = MongoClient("mongo:27017")

@app.route('/')
def todo():
    try:
        app.logger.info('Processing request...')

        users_db = client.users
        app.logger.info('Users db: {}'.format(users_db))
        test_collection = users_db.test_collection
        collection_names = users_db.list_collection_names()
        app.logger.info('Collection names: {}'.format(collection_names))

        test_collection.insert_one({"name": "jonas"})
        one_user = test_collection.find_one()
        app.logger.info('One user: {}'.format(one_user))
        all_users = test_collection.find()
        app.logger.info('All users: {}'.format(all_users))

        client.admin.command('ismaster')
    except Exception as ex:
        app.logger.error(ex)
        return "Server not available"
    return "Hello from the MongoDB client!\n"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=os.environ.get("FLASK_SERVER_PORT", 9090), debug=True)


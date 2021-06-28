#!/usr/bin/env python
import os, logging

from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)

client = MongoClient(os.environ.get("MONGO_DSN"), serverSelectionTimeoutMS=1000)

@app.route('/')
def todo():
    try:
        app.logger.info('Processing request...')
        db = client.test
        count = db.users.find().count()
        return f"Connected to Mongo!<br/><br/>There are {count} records in the users collection\n"
    except Exception as ex:
        app.logger.error(ex)
        return "Server not available"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=os.environ.get("FLASK_SERVER_PORT", 9090), debug=True)


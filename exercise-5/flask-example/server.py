#!/usr/bin/env python
import os, logging

from flask import Flask

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)


@app.route('/')
def todo():
    try:
        app.logger.info('Processing request...')
    except Exception as ex:
        app.logger.error(ex)
        return "Server not available"
    return "Hello from your brand new container!\n"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=os.environ.get("FLASK_SERVER_PORT", 9090), debug=True)


#!/usr/bin/env python
import os, logging

from flask import Flask

app = Flask(__name__)

logging.basicConfig(level=logging.DEBUG)

@app.route('/')
def todo():
    return "Hello from a flask API!\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=os.environ.get("FLASK_SERVER_PORT", 9090), debug=True)


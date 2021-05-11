FROM python:3-alpine3.9

WORKDIR /src

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

CMD [ "python", "server.py" ]

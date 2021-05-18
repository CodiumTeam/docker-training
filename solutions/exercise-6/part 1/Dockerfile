FROM python:3.9-alpine

WORKDIR /src

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

CMD [ "python", "server.py" ]

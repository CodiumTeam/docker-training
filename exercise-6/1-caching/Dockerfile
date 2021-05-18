FROM python:3.9-alpine

WORKDIR /src

COPY . .

RUN pip install -r requirements.txt --no-cache-dir

CMD [ "python", "server.py" ]

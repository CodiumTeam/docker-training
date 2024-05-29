ARG TAG=3.12.3

FROM python:${TAG}

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY server.py .

CMD ["python", "server.py"]

EXPOSE 9090

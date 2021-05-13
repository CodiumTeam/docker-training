ARG VERSION=3.9
FROM python:${VERSION}

COPY requirements.txt .
COPY server.py .

RUN pip install -r requirements.txt --no-cache-dir

CMD ["python", "server.py"]
FROM python:3.7

WORKDIR /src

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY server.py .

CMD ["python", "server.py"]

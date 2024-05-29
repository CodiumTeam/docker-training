ARG TAG=3.12

FROM python:${TAG}

RUN addgroup -g 5000 newuser \
  && adduser -G newuser -S \
    -u 5000 -s /bin/sh newuser

USER newuser

WORKDIR /home/newuser/app

COPY --chown=newuser:newuser requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY --chown=newuser:newuser server.py .

CMD ["python", "server.py"]

EXPOSE 9090
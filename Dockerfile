FROM python:latest

RUN mkdir -p /go/src/app

WORKDIR /go/src/app

COPY storeserver.py /go/src/app

EXPOSE 10505
EXPOSE 10506
EXPOSE 10520
EXPOSE 10849

CMD ["python2", "/go/src/app/storeserver.py"]

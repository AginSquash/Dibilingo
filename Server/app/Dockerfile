FROM python:3.9.1

LABEL MAINTAINER="Vladislav Vrublevsky"

ENV GROUP_ID=1000 \
    USER_ID=1000


VOLUME ["/var/www/"]

WORKDIR /var/www/

ADD . /var/www/
RUN pip install -r requirements.txt

CMD ["python", "app.py"]


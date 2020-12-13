FROM python:3.9.1

LABEL MAINTAINER="Vladislav Vrublevsky"

ADD . /var/www/

WORKDIR /var/www/

RUN pip install -r requirements.txt

CMD ["python", "app.py"]

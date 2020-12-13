FROM python:3.9.1

LABEL MAINTAINER="Vladislav Vrublevsky"

#ENV GROUP_ID=1000 \
#    USER_ID=1000



#vOLUME ["/var/www/"]
ADD . /var/www/

WORKDIR /var/www/

RUN pip install -r requirements.txt

CMD ["python", "app.py"]

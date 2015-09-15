FROM ruby:2.2.3-onbuild
RUN apt-get update
RUN apt-get -y install postgresql-client

CMD ["thin", "-R", "/usr/src/app/config.ru",  "start", "-p 5000"]

FROM rails:latest

MAINTAINER Florian Dejonckheere <florian@floriandejonckheere.be>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install -y supervisor

RUN mkdir -p /app/ /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV RAILS_ENV production

WORKDIR /tmp/
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

ADD . /app/
WORKDIR /app/

EXPOSE 3000

CMD "/usr/bin/supervisord"

FROM rails:latest

MAINTAINER Florian Dejonckheere <florian@floriandejonckheere.be>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install -y supervisor

WORKDIR /tmp/
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

RUN mkdir -p /app/ /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD . /app/
WORKDIR /app/

EXPOSE 3000

CMD /usr/bin/supervisord

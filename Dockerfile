FROM ruby:alpine

MAINTAINER Florian Dejonckheere <florian@floriandejonckheere.be>

RUN apk --update add --virtual build-dependencies build-base ruby-dev openssl-dev libxml2-dev libxslt-dev postgresql-dev libc-dev linux-headers nodejs tzdata git nodejs curl
RUN gem install bundler
RUN gem install nokogiri -- --use-system-libraries --with-xml2-config=/usr/local/bin/xml2-config --with-xslt-config=/usr/local/bin/xslt-config

ADD Gemfile /app/
ADD Gemfile.lock /app/

WORKDIR /app/
RUN bundle install --without development test

ADD . /app/

ENV RAILS_ENV production

RUN npm install bower
RUN rails bower:install

RUN chown -R nobody:nogroup /app
USER nobody

EXPOSE 8080
CMD ["/app/docker-entrypoint.sh"]

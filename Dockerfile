FROM floriandejonckheere/docker-ruby-node

MAINTAINER Florian Dejonckheere <florian@floriandejonckheere.be>

# Create user and group
RUN useradd thalariond --create-home --home-dir /app/ --shell /bin/false

ADD Gemfile /app/
ADD Gemfile.lock /app/

WORKDIR /app/

RUN bundle install --deployment --without development test

ADD . /app/
RUN chown -R thalariond:thalariond /app/

USER thalariond
ENV RAILS_ENV production

USER thalariond
RUN npm install bower
RUN rails bower:install

EXPOSE 8080
CMD ["/app/docker-entrypoint.sh"]

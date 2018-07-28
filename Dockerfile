FROM ruby:2.4-slim-stretch

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  nodejs \
  postgresql-server-dev-9.6

COPY . /app
WORKDIR /app

RUN set -xe && \
    gem install bundler && \
    bundle install

EXPOSE 4000
CMD ["bundle", "exec", "rails", "server", "-p", "4000"]

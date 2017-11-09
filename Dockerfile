FROM ruby:2.4-slim

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

COPY . /app
WORKDIR /app

ARG habitus_host
ARG habitus_port

RUN set -xe && \
    mkdir -p ~/.ssh/ && \
    curl -sL -o ~/.ssh/key http://$habitus_host:$habitus_port/v1/secrets/file/ssh_key && \
    curl -sL -o ~/.ssh/config http://$habitus_host:$habitus_port/v1/secrets/file/ssh_config && \
    chmod 600 ~/.ssh/key && \
    gem install bundler && \
    bundle install && \
    rm -rf ~/.ssh

EXPOSE 4000
CMD ["bundle", "exec", "rails", "server", "-p", "4000"]

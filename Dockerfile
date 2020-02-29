FROM ruby:2.7-buster
MAINTAINER Mikkel Kroman <mk@maero.dk>

RUN apt-get update && \
  apt-get install libsodium23 && \
  rm -rf /var/lib/apt/lists/*

RUN gem install bundler

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .

RUN bundle config set deployment true && \
  bundle config set without 'test development' && \
  bundle install

ENTRYPOINT bundle exec ruby /usr/src/app/bin/meta-rpc_client

FROM ruby:2.7.0

RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 apt-utils default-libmysqlclient-dev git libcurl3-dev cmake \
    libssl-dev pkg-config openssl imagemagick file nodejs npm

ENV RAILS_ROOT /rails-app

RUN mkdir -p $RAILS_ROOT
WORKDIR /rails-app

COPY Gemfile* ./
COPY Rakefile ./
RUN gem install bundler
RUN bundle config set path 'vendor/bundle'

RUN bundle install

COPY . /rails-app
VOLUME /rails-app

RUN chmod -R 755 $RAILS_ROOT/bin

EXPOSE 3000

CMD bundle exec puma -p 3000
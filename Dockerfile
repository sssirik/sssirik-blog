FROM ruby:3.3.5 AS build_base

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install --jobs 4

FROM build_base AS build_prod

COPY . .

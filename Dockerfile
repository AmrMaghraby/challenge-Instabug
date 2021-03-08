FROM ruby:2.6.2

# RUN apk update && apk --update add postgresql-client
#
# RUN apk --update add --virtual build_deps \
#     build-base ruby-dev libc-dev linux-headers \
#     openssl-dev postgresql-dev libxml2-dev libxslt-dev

RUN apt-get update
RUN apt-get install -y --no-install-recommends postgresql-client \
  build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev \
  curl
RUN rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
#RUN bundle update
COPY . .

# RUN apk del build_deps

#ENV RAILS_ENV production

EXPOSE 3000
# ENTRYPOINT ["sh", "./init.sh"]
# CMD ["rails", "server", "-b", "0.0.0.0"]

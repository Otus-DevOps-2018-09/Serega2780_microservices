FROM ruby:2.4-alpine3.8
ENV APP_HOME /app

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
RUN apk add bash \ 
    && apk add --no-cache build-base \ 
    && gem install bundler 

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD . $APP_HOME
RUN bundle install

CMD ["puma"]

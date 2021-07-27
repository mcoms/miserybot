FROM ruby
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
CMD ["ruby", "app.rb"]

COPY Gemfile Gemfile.lock ./
RUN bundle config set --global deployment true &&\
  bundle config set --global without development &&\
  bundle config set --global frozen true &&\
  bundle config set --global jobs $(nproc) &&\
  bundle install

COPY . ./

FROM ruby:3.3.6
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN apt-get update -qq \
&& apt-get install -y ca-certificates curl gnupg \
&& mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
&& NODE_MAJOR=20 \
&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn vim
RUN apt-get update && \
    apt-get install -y libvips42 libvips-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir /myapp
WORKDIR /myapp
RUN gem install bundler
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY yarn.lock /myapp/yarn.lock
RUN bundle install
RUN yarn install
COPY . /myapp
ENV RAILS_ENV=production
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
COPY bin/update_program_rankings.sh /usr/bin/update_program_rankings.sh
RUN chmod +x /usr/bin/update_program_rankings.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
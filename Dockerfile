FROM ruby:2.3.4

###############################################################################
# Install dependencies
###############################################################################

# Add Node.js package
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -

# Install Ubuntu packages

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client \
      g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base \
      gstreamer1.0-tools gstreamer1.0-x imagemagick libmagickcore-dev libmagickwand-dev \
      libzmq3-dev python3 python3-pip

###############################################################################
# Application environment setup (app folder, language settings, et c.)
###############################################################################

# Create working directory for application
RUN mkdir /app
WORKDIR /app


###############################################################################
# Install Ruby dependencies
###############################################################################

# Install bundler
RUN gem install bundler -v '~>1'

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

###############################################################################
# Copy application code (everything after that won't be cached)
###############################################################################

COPY . /app/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

###############################################################################
# Precompile assets
###############################################################################

RUN bundle exec rake assets:precompile RAILS_ENV=production

# # The only port we want to expose is
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

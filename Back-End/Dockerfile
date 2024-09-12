# syntax=docker/dockerfile:1

# Use a Ruby image as the base
FROM ruby:3.3.4-slim as base

# Set the working directory
WORKDIR /rails

# Set environment variables
ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=production

# Throw-away build stage to reduce size of final image
FROM base as build

# Install necessary packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock before bundle install
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile bootsnap code for faster boot times (optional)
RUN bundle exec bootsnap precompile app/ lib/

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:create db:migrate && bundle exec rails db:seed && bundle exec rails server -b '0.0.0.0'"]
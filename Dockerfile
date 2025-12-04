# frozen_string_literal: true

FROM ruby:3.3

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy Gemfile and gemspec first for better layer caching
COPY Gemfile magic_query.gemspec ./

# Copy Gemfile.lock if it exists (required for consistent builds)
# If it doesn't exist, generate it first with: bundle install
COPY Gemfile.lock ./

# Copy lib directory (required by gemspec for version file)
COPY lib/ ./lib/

# Install dependencies
RUN bundle install

# Copy the rest of the application
COPY . .

# Default command
CMD ["bash"]


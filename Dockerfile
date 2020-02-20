FROM ruby:2.7.0
# Update the Packages
RUN apt-get update
# Install container dependencies
RUN apt-get install -y vim libc-ares2 postgresql-client nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
# Install VIM to edit credentials.yml.enc file
ENV EDITOR="vim --wait"
# Set the work directory inside container
RUN mkdir /app
WORKDIR /app
# Copy the Gemfile inside the container
COPY Gemfile* /app/
# Install dependencies
RUN gem install bundler -v '2.1.4'
RUN bundle install --jobs 32 --retry 4
# Copy all the rest inside work directory
COPY . /app

# Use a specific Ruby version
FROM ruby:3.2.2

# Set the environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND noninteractive

LABEL MAINTAINER="Amir Pourmand"

# Install required packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    locales \
    imagemagick \
    build-essential \
    zlib1g-dev \
    jupyter-nbconvert \
    inotify-tools \
    procps \
    nodejs \
    npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Configure locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production

# Create a directory for the Jekyll site
RUN mkdir /srv/jekyll

# Copy only the Gemfile
COPY Gemfile /srv/jekyll/

# Set the working directory
WORKDIR /srv/jekyll

# Install Bundler
RUN gem install bundler

# Install project dependencies
RUN bundle install

# Copy the rest of the site
COPY . /srv/jekyll

EXPOSE 8080

# Copy the entry point script
COPY bin/entry_point.sh /tmp/entry_point.sh

# Set the entry point for the container
CMD ["/tmp/entry_point.sh"]
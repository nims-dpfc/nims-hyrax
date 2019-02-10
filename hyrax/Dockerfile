FROM ruby:2.6

# Setup build variables
# ARG RAILS_ENV="production"
ARG RAILS_ENV
ARG SECRET_KEY_BASE

ENV RAILS_ENV="$RAILS_ENV" \
    LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre \
    RAILS_LOG_TO_STDOUT=yes_please \
    PATH=/fits/fits-1.0.5/:$PATH \
    BUNDLE_JOBS=2 \
    APP_PRODUCTION=/data/ \
    APP_WORKDIR="/data"

# Add backports to apt-get sources
# Install libraries, dependencies, java and fits

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    libpq-dev \
    libxml2-dev libxslt1-dev \
    # libqt4-webkit libqt4-dev xvfb \
    nodejs \
    imagemagick \
    libreoffice \
    ghostscript \
    ffmpeg \
    ufraw \
    bzip2 unzip xz-utils \
    vim \
    # install open-jdk and ca-certs from jessie-backports
    && apt-get install -t jessie-backports -y --no-install-recommends openjdk-8-jre-headless ca-certificates-java \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN mkdir -p /fits/ \
    && wget -q http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip -O /fits/fits-1.0.5.zip \
    && unzip -q /fits/fits-1.0.5.zip -d /fits \
    && chmod a+x /fits/fits-1.0.5/fits.sh \
    && rm /fits/fits-1.0.5.zip

# copy gemfiles to production folder
COPY Gemfile Gemfile.lock $APP_PRODUCTION

# install gems to system - use flags dependent on RAILS_ENV
RUN cd $APP_PRODUCTION && \
    bundle config build.nokogiri --use-system-libraries \
    && if [ "$RAILS_ENV" = "production" ]; then \
            bundle install --without test:development; \
        else \
            bundle install --without production --no-deployment; \
        fi \
    && mv Gemfile.lock Gemfile.lock.built_by_docker

# copy the seeds
COPY ./seed /seed

# create a folder to store derivatives
RUN mkdir -p /derivatives

# copy the application
COPY . $APP_PRODUCTION
COPY docker-entrypoint.sh /bin/

# use the just built Gemfile.lock, not the one copied into the container and verify the gems are correctly installed
RUN cd $APP_PRODUCTION \
    && mv Gemfile.lock.built_by_docker Gemfile.lock \
    && bundle check

# generate production assets if production environment
RUN if [ "$RAILS_ENV" = "production" ]; then \
        cd $APP_PRODUCTION \
        && SECRET_KEY_BASE_PRODUCTION=0 bundle exec rake assets:clean assets:precompile; \
    fi

WORKDIR $APP_WORKDIR

# ARG SECRET_KEY_BASE="ec6aebaf837655680ac99c7a60a7b4ef61d9bcc320a9d3e78ef989bf309f8c9d63ee51b2997a0c5543fe20df30aa253c5fb19e1f065bfaf2be1224258904d45f"
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN chmod +x /bin/docker-entrypoint.sh

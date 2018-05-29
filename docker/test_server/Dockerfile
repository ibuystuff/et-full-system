FROM phusion/passenger-customizable:0.9.30
# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.0.*.sh
#RUN /pd_build/ruby-2.1.*.sh
#RUN /pd_build/ruby-2.2.*.sh
RUN /pd_build/ruby-2.3.*.sh
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/ruby-2.5.*.sh
#RUN /pd_build/jruby-9.1.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh

# ...put your own build instructions here...
RUN apt-get update && apt-get -y install pdftk tzdata postgresql gettext-base wget
RUN /pd_build/nodejs.sh

# ...put your own build instructions here...
RUN apt-get update && apt-get -y install pdftk tzdata postgresql

# Enable nginx and passenger
RUN rm -f /etc/service/nginx/down

# Enable the Redis service.
RUN rm -f /etc/service/redis/down

# Install minio
RUN bash -lc "cd /usr/local/bin && wget https://dl.minio.io/server/minio/release/linux-amd64/minio && chmod +x minio"

# Copy configs
RUN rm /etc/nginx/sites-enabled/default
ADD docker/test_server/env.conf /etc/nginx/main.d/webapp_env.conf

# Custom Services
RUN mkdir /etc/service/sidekiq_api

RUN mkdir /etc/service/sidekiq_et1

RUN mkdir /etc/service/s3
COPY docker/test_server/s3.sh /etc/service/s3/run
RUN chmod +x /etc/service/s3/run

# Create the minio_data directory for the minio server
RUN mkdir -p /home/app/minio_data; chown app:app /home/app/minio_data; chmod 0777 /home/app/minio_data

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /home/app/full_system; chown app:app /home/app/full_system
WORKDIR /home/app/full_system/systems

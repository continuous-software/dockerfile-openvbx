FROM tutum/lamp
MAINTAINER Amine Mouafik <amine@continuous.in.th>

# Install packages
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen unzip wget && \
apt-get -y install mysql-client php5-curl php5-memcache memcached php-pear build-essential

RUN sudo a2enmod rewrite
# Download OpenVBX into /app
RUN rm -fr /app && mkdir /app && \
wget https://api.github.com/repos/twilio/OpenVBX/zipball/1.2.17 && \
unzip 1.2.17 -d /tmp  && \
cp -a /tmp/twilio*/. /app && \
rm -rf /tmp/twilio*

# Add script to create openvbx database
ADD createdb.sh createdb.sh
ADD createdb.conf /etc/supervisor/conf.d/createdb.conf
RUN chmod 755 /*.sh
RUN chmod -R 777 /app/audio-uploads /app/OpenVBX/config

EXPOSE 80
CMD ["/run.sh"]

FROM docker.clarin.eu/base:1.0.1
MAINTAINER CLARIN System Operators "sysops@clarin.eu"

RUN apt-get update -y && \
    apt-get install -y openssl apache2 libapache2-mod-shib2 libapache2-mod-jk supervisor && \
    a2enmod ssl && \
    a2enmod shib2 && \
    a2enmod jk && \	
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod headers

# Configure apache2

RUN mkdir -p /etc/apache2/certs
COPY apache/apache_certs.config /etc/apache2/certs/apache_certs.config
COPY apache/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY apache/idp.ssl.conf /etc/apache2/sites-available/idp.ssl.conf
COPY apache/index.html /var/www/index.html
COPY apache/workers.properties etc/libapache2-mod-jk/workers.properties
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN a2ensite default-ssl && \
    a2ensite idp.ssl.conf
RUN chmod u+x /usr/bin/run-apache

# Configure shibboleth sp

RUN mkdir -p /etc/shibboleth/certs
COPY sp/shibboleth_certs.config /etc/shibboleth/certs/shibboleth_certs.config
COPY sp/shibboleth2.xml /etc/shibboleth/shibboleth2.xml
COPY sp/attribute-map.xml /etc/shibboleth/attribute-map.xml
COPY download-metadata.sh /usr/bin/download-metadata.sh
RUN mkdir -p mkdir -p /var/run/shibboleth
RUN chmod u+x /usr/bin/download-metadata.sh

# Configure supervisor

COPY startup.sh /usr/bin/startup.sh
RUN chmod u+x /usr/bin/startup.sh
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisor/run-apache /usr/bin/run-apache

# Expose ports, volumes and set command

VOLUME ["/etc/apache2/certs", "/etc/shibboleth/certs/", "/var/log/apache2", "/var/log/shibboleth"]

EXPOSE 80 443
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
CMD ["/usr/bin/startup.sh"]

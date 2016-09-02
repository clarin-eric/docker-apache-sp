#!/usr/bin/env bash

APACHE_NAME="apache2"
APACHE_CERT_PATH="/etc/apache2/certs"
APACHE_CERT_CONFIG_FILE="apache_certs.config"
APACHE_CERT_KEY_FILE="apache.key"
APACHE_CERT_FILE="apache.crt"

SHIBBOLETH_NAME="shibboleth"
SHIBBOLETH_CERT_PATH="/etc/shibboleth/certs"
SHIBBOLETH_CERT_CONFIG_FILE="shibboleth_certs.config"
SHIBBOLETH_CERT_KEY_FILE="shib.key"
SHIBBOLETH_CERT_FILE="shib.crt"

# Generate self-signed ssl certificates if they don't exist
# Requires 5 arguments:
#   Label
#   Path
#   Config filename
#   Key filename
#   Certificate filename
function prepare_certs {
    NAME=${1}
    PATH=${2}
    CONFIG=${3}
    KEY=${4}
    CERT=${5}

    if [ ! -e ${PATH}/${KEY} ]; then
        /bin/echo "Generating new ${NAME} certificate in: ${PATH}"
        /bin/mkdir -p /var/log/${NAME} && \
        /bin/mkdir -p ${PATH} && \
        /usr/bin/openssl req -config ${PATH}/${CONFIG} -new -x509 -days 365 -keyout ${PATH}/${KEY} -out ${PATH}/${CERT} >> /var/log/${NAME}/cert_generation.log 2>&1 && \
        /bin/chmod 0700 ${PATH}/${CERT} && \
        /bin/chmod 0700 ${PATH}/${KEY}
        rc=$?
        if [ ${rc} -ne 0 ]; then
            /bin/echo "Failed to generate certificate"
            exit 1
        fi
    else
        /bin/echo "Existing certificate found in: ${PATH}"
    fi
}

/bin/echo "** Preparing certificates"
prepare_certs ${APACHE_NAME} ${APACHE_CERT_PATH} ${APACHE_CERT_CONFIG_FILE} ${APACHE_CERT_KEY_FILE} ${APACHE_CERT_FILE}
prepare_certs ${SHIBBOLETH_NAME} ${SHIBBOLETH_CERT_PATH} ${SHIBBOLETH_CERT_CONFIG_FILE} ${SHIBBOLETH_CERT_KEY_FILE} ${SHIBBOLETH_CERT_FILE}

# cleanup pid files of any old process before starting supervisord
# prevents the stale pid syndrome: http://perfec.to/stalepid.html
find /var/run/ -type f -name "*.pid" -exec rm -f {} \;

/bin/echo "** Starting supervisord"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
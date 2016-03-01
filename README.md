Based on docker.clarin.eu/base

Packages:
openssl
apache2

ports:

* 80, http
* 443, https

volumes:

* `/etc/apache2/certs/`: apache certificates, will be generated if not supplied via volume
* `/etc/shibboleth/certs/`: shibboleth certificate, will be generated if not supplied via volume
* `/var/log/apache2/`: expose the apache2 daemon log files
* `/var/log/shibboleth`: expose the shibboleth sp daeamon log files

## Building

A Makefile is provided to allow for an easy workflow to build the docker images. Make sure you are in the directory where the Dockerfile is location and then run:

```
make
```


## Running

```
docker run -ti --rm -p 80:80 -p 443:443 docker.clarin.eu/apache2:1.0.0
```
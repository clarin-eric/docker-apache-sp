Based on docker.clarin.eu/base

Packages:

* openssl
* apache2 (including mod\_shib and mod\_jk)
* supervisord

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

Execute to following command:

```
docker run -ti --rm -p 80:80 -p 443:443 docker.clarin.eu/apache2:1.0.0
```

This should result in output similar to:

```
** Preparing certificates
Generating new apache2 certificate in: /etc/apache2/certs
Generating new shibboleth certificate in: /etc/shibboleth/certs
** Starting supervisord
2016-03-01 11:54:23,119 CRIT Supervisor running as root (no user in config file)
2016-03-01 11:54:23,123 INFO supervisord started with pid 19
2016-03-01 11:54:24,125 INFO spawned: 'shibd' with pid 21
2016-03-01 11:54:24,127 INFO spawned: 'apache2' with pid 22
2016-03-01 11:54:25,132 INFO success: shibd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2016-03-01 11:54:25,132 INFO success: apache2 entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

As you can see new (self-signed) certificates are generated and then supervisord takes care of starting both the shibd and the apache2 processes.
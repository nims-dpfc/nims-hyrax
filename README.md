## Introduction

[Nims-Hyrax](https://github.com/antleaf/nims-hyrax/) is an implementation of the Hyrax stack by [Cottage Labs](http://cottagelabs.com/) and [AntLeaf](http://antleaf.com/). It is built with Docker containers, which simplify development and deployment onto live services.


## Getting Started

Ensure you have docker and docker-compose. See [notes on installing docker](https://github.com/antleaf/nims-hyrax/blob/develop/README.md#installing-docker)

Open a console and try running `docker -h` and `docker-compose -h` to verify they are both accessible.

Create the environment file `.env`. You can start by copying the template file `.env.template` to `.env` and customizing the values to your setup.

To build and run the system in a development environment, issue the docker-compose `up` command:
```bash
$ docker-compose up --build
```
This will use the configuration in `docker-compose.yml` and `docker-compose-override.yml`. The reason the port exposure options are only present in the override file is so that these are not used in production. After some delay, you should see the application running:

 * You should see the Hyrax app at localhost:3000
 * Solr is available at localhost:8983/solr
 * Fedora is available at localhost:8080/fcrepo/rest
 * For convenience, the default workflows are loaded, the default admin set and collection types are created and 3 users are created, as detailed [here](https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/seed/setup.json)

### In production (& on the test server)
In order to secure our development, the 'production' app runs behind nginx. The access credentials are in our private repo. The extra password is just temporary during the development phase since we are using publicly accessible servers.

Docker-compose commands must be run from the root of the project respository (where the -compose.yml files are situated). On the `saku05` and demo servers, this is at `/srv/ngdr/nims-hyrax`. Ensure you have created a specific `.env` file in `hyrax/` on your production infrastructure (see the example) and run with:

    docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d

* The service will run without the ports of intermediary services such as Solr being exposed to the host.
* Hyrax is accessible behind http basic auth at port 443, http requests to port 80 will be redirected to https.
* To change or remove the http auth, edit the config in `docker/nginx/nginx.org` and the `.htpasswd` file. Credentials can be generated with the `htpasswd` command from the `apache2-utils` package (on Ubuntu).
* The nginx container will automatically try to ascertain free-of-charge a [Certbot / LetsEncrypt](https://certbot.eff.org) certificate.

In order for the certificate verification to succeed, it is important not to destroy and recreate the nginx container's volumes so fast as to hit the Certbot rate limit for new certificates. In addition, ports 80 and 443 on our application must be accessible from the Certbot servers (i.e. not blocked by firewall).

Since on the live server, the production compose file must be referred to each time a `docker-compose` command is made. To assist this, an alias similar to that below can be useful:

```bash
alias ngdrproddocker='docker-compose -f docker-compose.yml -f docker-compose-production.yml'
```

Some example usage:

```bash
# Bring the whole application up to run in the background, building the containers
ngdrproddocker up -d --build

# Halt the system
ngdrproddocker down

# Re-create the nginx container without affecting the rest of the system (and run in the background with -d)
ngdrproddocker up -d --build --no-deps --force-recreate nginx

# View the logs for the web application container
ngdrproddocker logs web

# Create a log dump file
ngdrproddocker logs web | tee web_logs_`date --iso-8601`
# (writes to e.g. web_logs_2019-03-27)

# View all running containers
docker ps
# (example output:)
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS                PORTS                                      NAMES
f42cf90d4494        nims-hyrax_nginx                 "sh -c 'nginx && cer…"   5 days ago          Up 5 days             0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   nims-hyrax_nginx_1
6da65933de09        nims-hyrax_web                   "bash -c /bin/docker…"   5 days ago          Up 14 hours           3000/tcp                                   nims-hyrax_web_1
ab9600b12f2d        nims-hyrax_workers               "bundle exec sidekiq"    5 days ago          Up 5 days                                                        nims-hyrax_workers_1
a9e18ff5eef7        ualbertalib/docker-fcrepo4:4.7   "catalina.sh run"        5 days ago          Up 5 days             8080/tcp                                   nims-hyrax_fcrepo_1
8a31c9b41e54        nims-hyrax_solr                  "/docker-entrypoint.…"   5 days ago          Up 5 days (healthy)   8983/tcp                                   nims-hyrax_solr_1
4382df4d4033        nims-hyrax_db                    "docker-entrypoint.s…"   5 days ago          Up 5 days (healthy)   5432/tcp                                   nims-hyrax_db_1
7580bf933d43        redis:5                          "docker-entrypoint.s…"   5 days ago          Up 5 days (healthy)   6379/tcp                                   nims-hyrax_redis_1

# Using its container name, you can run a shell in a container to view or make changes directly
docker exec -it nims-hyrax_nginx_1 sh
```

The data for the application is stored in docker named volumes as specified by the compose files. These are:

```bash
$ docker volume list
nims-hyrax_cache
nims-hyrax_db
nims-hyrax_derivatives
nims-hyrax_fcrepo
nims-hyrax_file_uploads
nims-hyrax_letsencrypt
nims-hyrax_redis
nims-hyrax_solr_home
```

These will persist when the system is brought down and rebuilt. Deleting them will require importers etc. to run again.

### Backups

There is [docker documentation](https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes) advising how to back up volumes and their data.

### System initialisation and configuration

* As mentioned above, there is a `.env` file containing application secrets. This **must not** be checked into version control!
* The system is configured on start-up using the `docker-entrypoint.sh` script, which configures users in the `seed/setup.json` file.
* Importers are run manually in the container using the rails console. See [The project wiki](https://github.com/antleaf/nims-hyrax/wiki) for more information.

### For Developers
We use the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) branching model, so ensure you set up
your project directory by running `git flow init` and accept the defaults.
[Installation for git-flow](https://github.com/nvie/gitflow/wiki/Installation).

```shell
Branch name for production releases: [master]
Branch name for "next release" development: [develop]
Feature branches? [feature/]
Bugfix branches? [bugfix/]
Release branches? [release/]
Hotfix branches? [hotfix/]
Support branches? [support/]
Version tag prefix? []
Hooks and filters directory? [<your-path-to-checked-out-repo>/nims-hyrax/.git/hooks]
```

The default branch in this repository is `develop`, and `master` should be used for stable releases only. After
finishing bugfixes or releases with `git-flow` remember to also push tags with `git push --tags`.

### Docker tips
[Docker cheat sheet](https://github.com/wsargent/docker-cheat-sheet)

#### Installing Docker

On `saku05` and the demo server on Digital Ocean we use docker version 18.09.3, and docker-compose version 1.23.2

1. Install Docker [by following step 1 of the Docker Compose installation tutorial](https://docs.docker.com/compose/install/) on your machine.

2. Make sure you don't need to `sudo` to run docker. [Instructions on set-up and how to test that it works.](https://docs.docker.com/engine/installation/linux/ubuntulinux/#/manage-docker-as-a-non-root-user)

3. Install [Docker Compose by following steps 2 and onwards from the Docker Compose installation Tutorial](https://docs.docker.com/compose/install/).

> Ubuntu Linux users, the command that Docker-Compose provides you with will not work since /usr/local/bin is not writeable by anybody but root in default Ubuntu setups. Use `sudo tee` instead, e.g.:

```bash
$ curl -L https://github.com/docker/compose/releases/download/[INSERT_DESIRED_DOCKER_COMPOSE_VERSION_HERE]/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null && sudo chmod a+x /usr/local/bin/docker-compose
```

4. Open a console and try running `docker -h` and `docker-compose -h` to verify they are both accessible.

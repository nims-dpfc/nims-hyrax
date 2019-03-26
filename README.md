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
In order to secure our development, the 'production' app runs behind nginx. The access credentials are in our private repo.

Ensure you have created a specific `.env` file in `hyrax/` on your production infrastructure (see the example) and run with:

    docker-compose -f docker-compose.yml -f docker-compose-production.yml up -d

* The service will run without the ports of intermediary services such as Solr being exposed to the host.
* Hyrax is accessible behind http basic auth at port 443, http requests to port 80 will be redirected to https.
* To change or remove the http auth, edit the config in `docker/nginx/nginx.org` and the `.htpasswd` file. Credentials can be generated with the `htpasswd` command from the `apache2-utils` package (on Ubuntu).
* The nginx container will automatically try to ascertain free-of-charge a [Certbot / LetsEncrypt](https://certbot.eff.org) certificate.

In order for the certificate verification to succeed, it is important not to destroy and recreate the nginx container's volumes so fast as to hit the Certbot rate limit for new certificates. In addition, ports 80 and 443 on our application must be accessible from the Certbot servers (i.e. not blocked by firewall).

Since on the live server, the production compose file must be referred to each time a `docker-compose` command is made. To assist this, an alias similar to that below can be useful:

```bash
TODO
```

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

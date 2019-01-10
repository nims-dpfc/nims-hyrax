## Introduction

[Nims-Hyrax](https://github.com/antleaf/nims-hyrax/) is an implementation of the Hyrax stack by [Cottage Labs](http://cottagelabs.com/) and [AntLeaf](http://antleaf.com/). It is built with Docker containers, which simplify development and deployment onto live services.


## Getting Started

Ensure you have docker and docker-compose

Open a console and try running `docker -h` and `docker-compose -h` to verify they are both accessible.

Create the environment file `.env.production` and set the postgres database username and password and the secret key. You can use the `example.env.production` file as template.

To build and run the system, issue the `up` command to docker-compose: 
```bash
$ docker-compose up --build
```
 * You should see the Hyrax app at localhost:3000
 * Solr is available at localhost:8983/solr
 * Fedora is available at localhost:8080/fcrepo/rest
 * For conveneince, the default workflows are loaded, the default admin set and collection types are created and 3 users are created, as detailed [here](https://github.com/antleaf/nims-hyrax/blob/develop/hyrax/seed/setup.json)

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

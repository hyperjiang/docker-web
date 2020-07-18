# docker-web

[![Docker Pulls](https://img.shields.io/docker/pulls/hyperjiang/web.svg)](https://hub.docker.com/r/hyperjiang/web)
[![License](https://img.shields.io/github/license/hyperjiang/docker-web.svg)](https://github.com/hyperjiang/docker-web)

*nginx + php5 + php7 + nodejs, built on ubuntu 18.04 (bionic)*

Working directory is `/app`.

If you need to run customized scripts, you can mount your scripts into `/scripts` folder.

There are two pre-defined upstreams: `php5` and `php7`, see [domain_example.conf](https://github.com/hyperjiang/docker-web/blob/master/domain_example.conf) for reference.

# docker-twimg2rss

Execution environment by Docker for [twimg2rss](https://github.com/kiyoad/twimg2rss)

## Getting Started
### Prerequisites

What things you need to install the software.

* Connectivity to the INTERNET
    * It is a twimg2rss runtime environment that Feed Fetcher like Feedly can access from INTERNET side.
* Docker on Linux
* docker-compose

```
$ docker version
Client:
 Version:      18.03.1-ce
 API version:  1.37
 Go version:   go1.9.5
 Git commit:   9ee9f40
 Built:        Thu Apr 26 07:17:20 2018
 OS/Arch:      linux/amd64
 Experimental: false
 Orchestrator: swarm

Server:
 Engine:
  Version:      18.03.1-ce
  API version:  1.37 (minimum version 1.12)
  Go version:   go1.9.5
  Git commit:   9ee9f40
  Built:        Thu Apr 26 07:15:30 2018
  OS/Arch:      linux/amd64
  Experimental: false

$ docker-compose version
docker-compose version 1.21.0, build 5920eb0
docker-py version: 3.3.0
CPython version: 3.5.2
OpenSSL version: OpenSSL 1.0.2g  1 Mar 2016
```


### Installing

1. Edit `my_config`.
    * `YOUR_DOMAIN`: Used in URL embedded in `twimg2rss.xml`.
        * This URL should be the same as what Feed Fetcher like Feedly uses to access `twimg2rss.xml`.
            * Ex.: `http://YOUR_DOMAIN/twimg2rss.xml`
        * If `YOUR_DOMAIN` is different from the domain of your twimg2rss runtime environment, how `twimg2rss.xml` is recognized will be up to the Feed Fetcher.
1. Run `build.sh` and wait a while.
    * `$ ./build.sh`
1. Edit `config.ini` in `CONFIGDIR`.
    * Default `CONFIGDIR`: `${HOME}/.twimg2rss/conf`
    * Change the following 4 places.(see Usage in [twimg2rss README.md](https://github.com/kiyoad/twimg2rss/blob/master/README.md))
        * `tw_consumer_key`: Your Twitter Consumer Key (API Key).
        * `tw_consumer_secret`: Your Twitter Consumer Secret (API Secret).
        * `tw_access_token`: Your Twitter Access Token.
        * `tw_access_token_secret`: Your Twitter Access Token Secret.


## Running

* Run `docker-compose up -d` starts twimg2rss runtime environment.
    * `twimg2rss.xml` in `HTMLDIR` will be created at most 15 minutes later.(see `twimg2rss.crontab`)
        * Default `HTMLDIR`: `${HOME}/.twimg2rss/html`
    * At this point, the execution environment of twimg2rss can be accessed from the INTERNET side by the nginx container.
        * Confirm that you can access `http://YOUR_DOMAIN/twimg2rss.xml` with the browser.
        * Or, create an appropriate `index.html`, place it in `HTMLDIR`, and confirm that you can access it with the browser.
* The log file is created in `LOGDIR`.
    * Default `LOGDIR`: `${HOME}/.twimg2rss/logdir`
    * Access log of nginx etc can be referred to by `docker-compose logs -f`.


## License

This project is licensed under the MIT License.

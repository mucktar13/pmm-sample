### How To Run

Install [docker] on local machine

Start the server by executing this code from the root directory where `docker-compose.yml` placed.
```sh
$ docker-compose build
$ docker-compose up -d
```

To see containers output
```sh
$ docker-compose logs -f
```

To stop docker containers
```sh
$ docker-compose down
```
To run pmmclient with interactive shell
```sh
docker-compose run --rm pmmclient
```

Go to http://localhost:8001/ to see percona dashboard

[docker]: <https://docs.docker.com/docker-for-windows/install/>

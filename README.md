# MySQL | Ubuntu

Current MySQL Docker Image from Ubuntu. Receives security updates and rolls to newer MySQL or Ubuntu LTS. This repository is exempted from per-user rate limits. For [LTS Docker Image](https://ubuntu.com/security/docker-images) versions of this image, see `lts/mysql`. 


## About MySQL

MySQL is a fast, stable and true multi-user, multi-threaded SQL database server. SQL (Structured Query Language) is the most popular database query language in the world. The main goals of MySQL are speed, robustness and ease of use. Read more on the [MySQL website](https://dev.mysql.com/doc/refman/8.0/en/).


## Tags and Architectures
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
Up to 5 years free security maintenance `from lts/mysql`.

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
Up to 10 years customer security maintenance `from store/canonical/mysql`.

_Tags in italics are not available in ubuntu/mysql but are shown here for completeness._

| Channel Tag | | | Currently | Architectures |
|---|---|---|---|---|
| **`8.0-21.04_beta`** &nbsp;&nbsp; | | | MySQL 8.0.23 on Ubuntu 21.04 | `amd64`, `arm64`, `s390x` |
| _`track_risk`_ |

Channel tag shows the most stable channel for that track ordered `stable`, `candidate`, `beta`, `edge`. More risky channels are always implicitly available. So if `beta` is listed, you can also pull `edge`. If `candidate` is listed, you can pull `beta` and `edge`. When `stable` is listed, all four are available. Images are guaranteed to progress through the sequence `edge`, `beta`, `candidate` before `stable`.


## Usage

Launch this image locally:

```sh
docker run -d --name mysql-container -e TZ=UTC -p 30306:3306 -e MYSQL_ROOT_PASSWORD=My:S3cr3t/ ubuntu/mysql:8.0-21.04_beta
```
Access your MySQL server at `localhost:30306`.

#### Parameters

| Parameter | Description |
|---|---|
| `-e TZ=UTC` | Timezone. |
| `-e MYSQL_ROOT_PASSWORD=secret_for_root` | Set the password for the `root` user. This option is **mandatory** and **must not be empty**. |
| `-e MYSQL_PASSWORD=secret` | Set the password for the `MYSQL_USER` user. |
| `-e MYSQL_USER=john` | Create a new user with superuser privileges. This is used in conjunction with `MYSQL_PASSWORD`. |
| `-e MYSQL_DATABASE=db_test` | Set the name of the default database. |
| `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes` | Set up a blank password for the `root` user. **This is not recommended to be used in production, make sure you know what you are doing**. |
| `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` | Generate a random initial password for the `root` user using `pwgen`. It will be printed in the logs, search for `GENERATED ROOT PASSWORD`. |
| `-e MYSQL_ONETIME_PASSWORD=yes` | Set `root` user as experide once initialization is complete, forcing a password change on first login. |
| `-e MYSQL_INITSB_SKIP_TZINFO=yes` | Timezone data is automatically loaded via entrypoint script, set this variable to any non-empty value to disable it. |
| `-p 30306:3306` | Expose MySQL server on `localhost:30306`. |
| `-v /path/to/data:/var/lib/mysql` | Persist data instead of initializing a new database every time you launch a new container. |
| `-v /path/to/config/files/:/etc/mysql/mysql.conf.d/` | Local [configuration files](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html) (try this [example my.cnf](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/mysql/plain/examples/config/my.cnf)). |

#### Initialization Scripts

One can also add initialization scripts to their containers. This includes `*.sql`, `.sql.gz`, and `*.sh` scripts, and you just need to put them inside the  `/docker-entrypoint-initdb.d` directory inside the container. After MySQL initialization is done and the default database and user are created, the scripts are executed in the following order:

* Run any `*.sql` files in alphabetically order. By default the target database is specified via `MYSQL_DATABASE`.
* Run any executable `*.sh` scripts in alphabetically order.
* Source any non-executable `*.sh` scripts in alphabetically order.

All of this is done before the MySQL service is started. Keep in mind if your database directory is not empty (contains pre-existing database) they will be left untouched.


#### Testing/Debugging

To debug the container:

```sh
docker logs -f mysql-container
```

To get an interactive shell:

```sh
docker exec -it mysql-container /bin/bash
```

This image also includes the `mysql` client for interactive container use:

```sh
$ docker network create mysql-network
$ docker network connect mysql-network mysql-container
$ docker run -it --rm --network mysql-network ubuntu/mysql:8.0-21.04_beta mysql -hmysql-container -uroot -p
```
The password will be asked and you can enter `My:S3cr3t/`. Now, you are logged in and can enjoy your new instance.

## Deploy with Kubernetes

Works with any Kubernetes; if you don't have one, we recommend you [install MicroK8s](https://microk8s.io/) and `microk8s.enable dns storage` then `snap alias microk8s.kubectl kubectl`.

Download
[my-custom.cnf](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/mysql/plain/examples/config/my-custom.cnf) and
[mysql-deployment.yml](https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/mysql/plain/examples/mysql-deployment.yml) and set `containers.mysql.image` in `mysql-deployment.yml` to your chosen channel tag (e.g. `ubuntu/mysql:8.0-21.04_beta`), then:

```sh
kubectl create configmap mysql-config --from-file=main-config=my-custom.cnf
kubectl apply -f mysql-deployment.yml
```

You will now be able to connect to the MySQL server on `localhost:30306`.

## Bugs and feature requests

If you find a bug in our image or want to request a specific feature, please file a bug here:

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

Please title the bug "`mysql: <issue summary>`". Make sure to include the digest of the image you are using, from:

```sh
docker images --no-trunc --quiet ubuntu/mysql:<tag>
```



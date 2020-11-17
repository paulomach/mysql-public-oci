# MySQL | Ubuntu

## About MySQL

MySQL is a fast, stable and true multi-user, multi-threaded SQL database
server. SQL (Structured Query Language) is the most popular database query
language in the world. The main goals of MySQL are speed, robustness and ease
of use. Read more in [the official documentation](https://dev.mysql.com/doc/refman/8.0/en/).

## Tags

- `8.0.22-focal`, `8.0.22`, `8.0-focal`, `8.0`, `8-focal`, `8`, `focal`, `beta` - **/!\ this is a beta release**

### Architectures supported

- `amd64`, `arm64`, `s390x`

## Usage

### Docker CLI

```sh
$ docker network create --driver bridge mysql-net
$ docker run -d --name mysql-instance --network mysql-net -e TZ=Europe/London -e MYSQL_ROOT_PASSWORD=My$seCret squeakywheel/mysql:edge
```

#### Parameters

| Parameter | Description |
|---|---|
| `-e TZ=UTC` | Timezone |
| `-e MYSQL_ROOT_PASSWORD=secret_for_root` | Set the password for the `root` user. This option is **mandatory** and **must not be empty**. |
| `-e MYSQL_PASSWORD=secret` | Set the password for the `MYSQL_USER` user. |
| `-e MYSQL_USER=john` | Create a new user with superuser privileges. This is used in conjunction with `MYSQL_PASSWORD` |
| `-e MYSQL_DATABASE=db_test` | Set the name of the default database. |
| `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes` | Set up a blank password for the `root` user. **This is not recommended to be used in production, make sure you know what you are doing**. |
| `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` | Generate a random initial password for the `root` user using `pwgen`. It will be printed in the logs, search for `GENERATED ROOT PASSWORD`. |
| `-e MYSQL_ONETIME_PASSWORD=yes` | Set `root` user as experide once initialization is complete, forcing a password change on first login. |
| `-e MYSQL_INITSB_SKIP_TZINFO=yes` | Timezone data is automatically loaded via entrypoint script, set this variable to any non-empty value to disable it. |
| `-p 30306:3306` | Expose MySQL server on `localhost:30306` |
| `-v /path/to/data:/var/lib/mysql` | Persist data instead of initializing a new database every time you launch a new container |
| `-v /path/to/config/files/:/etc/mysql/mysql.conf.d/` | Pass your own [configuration files](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html) to the container |

#### Initialization Scripts

One can also add initialization scripts to their containers. This includes `*.sql`, `.sql.gz`, and `*.sh` scripts, and you just need to put them inside the  `/docker-entrypoint-initdb.d` directory inside the container. After MySQL initialization is done and the default database and user are created, the scripts are executed in the following order:

* Run any `*.sql` files in alphabetically order. By default the target database is specified via `MYSQL_DATABASE`.
* Run any executable `*.sh` scripts in alphabetically order.
* Source any non-executable `*.sh` scripts in alphabetically order.

All of this is done before the MySQL service is started. Keep in mind if your database directory is not empty (contains pre-existing database) they will be left untouched.

#### Testing/Debugging

In case you need to debug what it is happening with the container you can run `docker logs <name_of_the_container>`. But if you want to get access to an interactive shell run:

```sh
$ docker exec -it <name_of_the_container> /bin/bash
```

With this same image, you can launch another container as a client to connect to your `mysql` sevrer running in the first container.

```sh
$ docker run -it --rm --network mysql-net squeakywheel/mysql:edge mysql -hmysql-instance -Uroot -p
```
The password will be asked and you can enter `My$seCret`. Now, you are logged in and can enjoy your new instance.

## Deploy with Kubernetes

You can use your favorite Kubernetes distribution; if you don't have one, consider [installing MicroK8s](https://microk8s.io/).

With microk8s running, enable the `dns` and `storage` add-ons:
```sh
$ microk8s enable dns storage
 ```

Create a configmap for the configuration file (write your `my.cnf` file based on the upstream documentation [here](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html)):

```sh
$ microk8s kubectl create configmap mysql-config --from-file=main-config=config/my-custom.cnf
```

Use the sample deployment yaml provided [here](https://git.launchpad.net/~canonical-server/ubuntu-server-oci/+git/mysql/plain/examples/mysql-deployment.yml).

<details>
  <summary>Apply the `mysql-deployment.yml` (click to expand)</summary>

```yaml
# mysql-deployment.yml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: microk8s-hostpath
  resources:
    requests:
      storage: 500M
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: squeakywheel/mysql:edge
        env:
        - name: MYSQL_RANDOM_ROOT_PASSWORD
          value: "yes"
        - name: MYSQL_PASSWORD
          value: "myS&cret"
        - name: MYSQL_USER
          value: "john"
        volumeMounts:
        - name: mysql-config-volume
          mountPath: /etc/mysql/mysql.conf.d/my-custom.cnf
          subPath: my-custom.cnf
        - name: mysql-data
          mountPath: /var/lib/mysql
        ports:
        - containerPort: 3306
          name: mysql
          protocol: TCP
      volumes:
        - name: mysql-config-volume
          configMap:
            name: mysql-config
            items:
            - key: main-config
              path: my-custom.cnf
        - name: mysql-data
          persistentVolumeClaim:
            claimName: mysql-volume-claim
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  type: NodePort
  selector:
    app: mysql
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
    nodePort: 30306
    name: mysql
```

</details>

```sh
$ microk8s kubectl apply -f mysql-deployment.yml
```

You will now be able to connect to the MySQL server on `localhost:30306`.

## Bugs and Features request

If you find a bug in our image or want to request a specific feature file a bug here:

https://bugs.launchpad.net/ubuntu-server-oci/+filebug

In the title of the bug add `mysql: <reason>`.

Make sure to include:

* The digest of the image you are using, you can find it using this command replacing `<tag>` with the one you used to run the image:
```sh
$ docker images --no-trunc --quiet squeakywheel/mysql:<tag>
```
* Reproduction steps for the deployment
* If it is a feature request, please provide as much detail as possible

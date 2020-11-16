# Running the examples

## docker-compose

Install `docker-compose` from the Ubuntu archive:

```
$ sudo apt install -y docker-compose
```

Call `docker-compose` from the examples directory:

```
$ docker-compose up -d
```

MySQL will be running and available via port `3306` on your host. The password of the `john` user will be `myS&cret`. To stop it run:

```
$ docker-compose down
```

# Microk8s

With microk8s running, enable the `dns` and `storage` add-ons:

```
$ microk8s enable dns storage
```

Create a configmap for the configuration files:

```
$ microk8s kubectl create configmap mysql-config \
		--from-file=main-config=config/my-custom.cnf
```

Apply the `mysql-deployment.yml`:

```
$ microk8s kubectl apply -f mysql-deployment.yml
```

MySQL will be running and available via port `30306` on your host. The password of the `john` user will be `myS&cret`.

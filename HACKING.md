# Contributing

In order to contribute to the MySQL OCI image do the following:

* Create a new branch.
* Make your changes. Keep your commits logically separated. If it is fixing a bug do not forget to mention it in the commit message.
* Build a new image with your changes. You can use the following command:

```
$ docker build -t ubuntu/mysql:test -f Dockerfile .
```

* Test the new image. Run it in some way that exercises your changes, you can also check th README.md file.
* If everything goes well submit a merge proposal.

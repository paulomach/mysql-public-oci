# Contributing

In Ubuntu, MySQL is available as a `.deb` package.  For this reason,
this image was built by installing the MySQL Ubuntu Focal package
inside a docker container.

In order to contribute to the MySQL OCI image, do the following:

* Create a new branch.

* Make your changes. Keep your commits logically separated. If it is
  fixing a bug do not forget to mention it in the commit message.

* Build a new image with your changes. You can use the following command:

```
$ docker build -t ubuntu/mysql:test .
```

* Test the new image. Run it in some way that exercises your changes,
  you can also check the README.md file.

* If everything goes well submit a merge proposal.

# Generating the documentation

The documentation (`README.md`) is generated using templates.  In
order to do that, you need to follow some steps.

```
$ pwd
~/work/mysql
$ cd ..
$ git clone https://github.com/misterw97/RenderDown
$ cd mysql
$ make all-doc
```

If you already have the `RenderDown` repository cloned somewhere else,
you can tell `make` about it:

```
$ RENDERDOWN=/path/to/renderdown.py make all-doc
```

# Hacking the documentation templates

The repository containing the templates is located at:

https://code.launchpad.net/~canonical-server/ubuntu-docker-images/+git/templates

The specific data for this image's template can be found inside the
`data/` directory.


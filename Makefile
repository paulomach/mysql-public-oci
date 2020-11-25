RENDERDOWN ?= ../RenderDown/renderdown.py
PYTHON ?= python3

README_TEMPLATE = templates/README_DOCKERHUB.md

HACKING_TEMPLATE = templates/HACKING_deb.md

all: all-doc

all-doc: clean-doc readme

get-templates:
	wget -nv -e "robots=off" -nd -r -np -P templates https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/templates/plain/templates/

readme: get-templates
	mv -v $(README_TEMPLATE) templates/README.md
	mv -v $(HACKING_TEMPLATE) templates/HACKING.md
	$(PYTHON) $(RENDERDOWN) templates/README.md > README.md
	$(PYTHON) $(RENDERDOWN) templates/HACKING.md > HACKING.md

clean: clean-doc

clean-doc:
	rm -frv templates/ README.md

.PHONY: readme clean clean-doc all all-doc get-templates

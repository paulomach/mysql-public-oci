RENDERDOWN ?= ../RenderDown/renderdown.py
PYTHON ?= python3

README_TEMPLATE = templates/README_DOCKERHUB.md

HACKING_TEMPLATE = templates/HACKING_deb.md

TEMPLATE_FILES = $(README_TEMPLATE) \
	$(HACKING_TEMPLATE) \
	templates/channels_message.md \
	templates/common_usage.md \
	templates/header.md

all: all-doc

all-doc: clean-doc readme

templates/%.md:
	curl https://git.launchpad.net/~canonical-server/ubuntu-docker-images/+git/templates/plain/$@ --create-dirs --output $@

readme: $(TEMPLATE_FILES)
	mv -v $(README_TEMPLATE) templates/README.md
	mv -v $(HACKING_TEMPLATE) templates/HACKING.md
	$(PYTHON) $(RENDERDOWN) templates/README.md > README.md
	$(PYTHON) $(RENDERDOWN) templates/HACKING.md > HACKING.md

clean: clean-doc

clean-doc:
	rm -frv $(TEMPLATE_FILES) templates/ README.md

.PHONY: readme clean clean-doc all all-doc

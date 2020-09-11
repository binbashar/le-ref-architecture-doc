.PHONY: help
SHELL                    := /bin/bash
MAKEFILE_PATH            := ./Makefile
MAKEFILES_DIR            := ./@bin/makefiles

LOCAL_OS_USER_ID         := $(shell id -u)
LOCAL_OS_GROUP_ID        := $(shell id -g)
MKDOCS_DOCKER_IMG        := squidfunk/mkdocs-material:5.5.12

help:
	@echo 'Available Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " - \033[36m%-18s\033[0m %s\n", $$1, $$2}'

#==============================================================#
# DOCUMENTATION                                                #
#==============================================================#
docs-deploy-gh: ## deploy to Github pages
	docker run --rm -it \
	-v ~/.ssh:/root/.ssh \
	-v ${PWD}:/docs \
	${MKDOCS_DOCKER_IMG} gh-deploy --clean \
	--message "CircleCI deploying to gh-pages [ci skip]" \
	--remote-branch gh-pages
	sudo chown -R ${LOCAL_OS_USER_ID}:${LOCAL_OS_GROUP_ID} ./site
	rm -rf ./site

docs-live: ## Build and launch a local copy of the documentation website in http://localhost:8000
	@docker run --rm -it \
		-p 8000:8000 \
		-v ${PWD}:/docs \
		${MKDOCS_DOCKER_IMG}

docs-check-dead-links: ## Check if the documentation contains dead links.
	@docker run -t \
	  -v $$PWD:/tmp aledbf/awesome_bot:0.1 \
	  --allow-dupe \
	  --allow-redirect $(shell find $$PWD -mindepth 1 -name "*.md" -printf '%P\n' | grep -v vendor | grep -v Changelog.md)
	sudo chown -R ${LOCAL_OS_USER_ID}:${LOCAL_OS_GROUP_ID} ab-results-*
	rm -rf ab-results-*

#==============================================================#
# INITIALIZATION                                               #
#==============================================================#
init-makefiles: ## initialize makefiles
	rm -rf ${MAKEFILES_DIR}
	mkdir -p ${MAKEFILES_DIR}
	git clone https://github.com/binbashar/le-dev-makefiles.git ${MAKEFILES_DIR}
	echo "" >> ${MAKEFILE_PATH}
	sed -i '/^#include.*/s/^#//' ${MAKEFILE_PATH}

#
## IMPORTANT: Automatically managed
## Must NOT UNCOMMENT the #include lines below
#
#include ${MAKEFILES_DIR}/circleci/circleci.mk
#include ${MAKEFILES_DIR}/release-mgmt/release.mk

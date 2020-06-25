.PHONY: help
SHELL                    := /bin/bash
MAKEFILE_IMPORT_CIRCLECI := ./@bin/makefiles/circleci/Makefile.circleci

LOCAL_OS_USER_ID         := $(shell id -u)
LOCAL_OS_GROUP_ID        := $(shell id -g)

define MAKE_CIRCLECI
make \
-f ${MAKEFILE_IMPORT_CIRCLECI}
endef

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
	squidfunk/mkdocs-material gh-deploy --clean \
	--message "CircleCI deploying to gh-pages [ci skip]" \
	--remote-branch gh-pages
	sudo chown -R ${LOCAL_OS_USER_ID}:${LOCAL_OS_GROUP_ID} ./site
	rm -rf ./site

docs-live: ## Build and launch a local copy of the documentation website in http://localhost:3000
	@docker run --rm -it \
		-p 8000:8000 \
		-v ${PWD}:/docs \
		squidfunk/mkdocs-material:5.2.3

docs-check-dead-links: ## Check if the documentation contains dead links.
	@docker run -t \
	  -v $$PWD:/tmp aledbf/awesome_bot:0.1 \
	  --allow-dupe \
	  --allow-redirect $(shell find $$PWD -mindepth 1 -name "*.md" -printf '%P\n' | grep -v vendor | grep -v Changelog.md)

#==============================================================#
# CIRCLECI                                                     #
#==============================================================#
circleci-validate-config: ## Validate A CircleCI Config (https://circleci.com/docs/2.0/local-cli/)
	${MAKE_CIRCLECI} circleci-validate-config
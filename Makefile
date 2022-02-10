# Configuration
# -------------

APP_NAME := $(shell grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')
APP_VERSION := $(shell grep 'version:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/version://' -e 's/[:,]//g')
DOCKER_IMAGE_TAG ?= $(APP_VERSION)
SBOM_FILE_NAME_CY ?= $(APP_NAME).$(APP_VERSION)-cyclonedx-sbom.1.0.0
SBOM_FILE_NAME_SPDX ?= $(APP_NAME).$(APP_VERSION)-spdx-sbom.1.0.0

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo  "\033[34mEnvironment\033[0m"
	@echo  "\033[34m---------------------------------------------------------------\033[0m"
	@printf "\033[33m%-23s\033[0m" "APP_NAME"
	@printf "\033[35m%s\033[0m" $(APP_NAME)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "APP_VERSION"
	@printf "\033[35m%s\033[0m" $(APP_VERSION)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_IMAGE_TAG"
	@printf "\033[35m%s\033[0m" $(DOCKER_IMAGE_TAG)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "CYCLONEDX FILENAME"
	@printf "\033[35m%s\033[0m" $(SBOM_FILE_NAME_CY)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "SPDX FILENAME"
	@printf "\033[35m%s\033[0m" $(SBOM_FILE_NAME_SPDX)
	@echo ""

.PHONY: targets
targets:
	@echo  "\033[34mTargets\033[0m"
	@echo  "\033[34m---------------------------------------------------------------\033[0m"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

.PHONY: compile
compile: ## compile the project
	mix compile

.PHONY: lint-compile
lint-compile: ## check for warnings in functions used in the project
	mix compile --warnings-as-errors --force

.PHONY: lint-format
lint-format: ## Check if the project is well formated using elixir formatter
	mix format --dry-run --check-formatted

.PHONY: lint-questions
lint-questions: ## Check if the questions will be correctly parsed
	mix gen.answers
	mix validate.questions

.PHONY: lint-credo
lint-credo: ## Check for credo compliance
	mix credo --strict

.PHONY: lint-unused
lint-unused: ## Check for unused functions
	mix unused 

.PHONY: lint
lint: lint-compile lint-format lint-questions lint-credo ## Check if the project follows set conventions such as formatting


.PHONY: test
test: ## Run the test suite
	mix test

.PHONY: format
format: mix format ## Run formatting tools on the code


.PHONY: sbom sbom_fast
sbom: ## creates sbom for both  npm and hex dependancies
	mix deps.get && mix sbom.cyclonedx -o elixir_bom.xml
	cd assets/  && npm install && npm install -g @cyclonedx/bom@3.1.1 && cyclonedx-bom -o ../$(SBOM_FILE_NAME_CY).xml && cd ..
	./cyclonedx-cli merge --input-files ./$(SBOM_FILE_NAME_CY).xml ./elixir_bom.xml --output-file $(SBOM_FILE_NAME_CY)-all.xml
	./cyclonedx-cli convert --input-file $(SBOM_FILE_NAME_CY).xml --output-file $(SBOM_FILE_NAME_CY).json
	./cyclonedx-cli convert --input-file $(SBOM_FILE_NAME_CY).json --output-format spdxtag --output-file $(SBOM_FILE_NAME_SPDX).spdx
	cp $(SBOM_FILE_NAME_CY).* priv/static/.well-known/sbom
	cp $(SBOM_FILE_NAME_SPDX).* priv/static/.well-known/sbom

sbom_fast: ## creates sbom without dependancy instalment, assumes you have cyclonedx-bom javascript package installed globally
	mix sbom.cyclonedx -o elixir_bom.xml
	cd assets/ && cyclonedx-bom -o ../$(SBOM_FILE_NAME_CY).xml && cd ..
	./cyclonedx-cli merge --input-files ./$(SBOM_FILE_NAME_CY).xml ./elixir_bom.xml --output-file $(SBOM_FILE_NAME_CY)-all.xml
	./cyclonedx-cli convert --input-file $(SBOM_FILE_NAME_CY)-all.xml --output-file $(SBOM_FILE_NAME_CY).json
	./cyclonedx-cli convert --input-file $(SBOM_FILE_NAME_CY).json --output-format spdxtag --output-file $(SBOM_FILE_NAME_SPDX).spdx
	cp $(SBOM_FILE_NAME_CY).* priv/static/.well-known/sbom
	cp $(SBOM_FILE_NAME_SPDX).* priv/static/.well-known/sbom


release: ## Build a release of the application with MIX_ENV=prod
	MIX_ENV=prod mix deps.get --only prod
	MIX_ENV=prod mix compile
	npm install --prefix ./assets
	MIX_ENV=prod mix assets.deploy
	MIX_ENV=prod mix release

.PHONY: docker-image
docker-image: #builds docker image
	docker build . -t quadquiz:$(APP_VERSION)

.PHONY: push-image-gcp push-and-serve deploy-existing-image
push-image-gcp: ## push image to gcp
	@if [[ "$(docker images -q gcr.io/duncan-openc2-plugfest/quadquiz:$(APP_VERSION)> /dev/null)" != "" ]]; then \
  @echo "Removing previous image $(APP_VERSION) from your machine..."; \
	docker rmi gcr.io/duncan-openc2-plugfest/quadquiz:$(APP_VERSION);\
	fi
	docker build . -t gcr.io/duncan-openc2-plugfest/quadquiz:$(APP_VERSION) --no-cache

	gcloud container images delete gcr.io/duncan-openc2-plugfest/quadquiz:$(APP_VERSION) --force-delete-tags  || echo "no image to delete on the remote"
	docker push gcr.io/duncan-openc2-plugfest/quadquiz:$(APP_VERSION)

push-and-serve-gcp: push-image-gcp deploy-existing-image ## creates docker image then push to gcp and launches an instance with the image

.PHONY: deploy-existing-image
deploy-existing-image: ## creates an instance using existing gcp docker image
	gcloud compute instances create-with-container $(instance-name) \
		--container-image=gcr.io/duncan-openc2-plugfest/quadquiz:$(DOCKER_IMAGE_TAG) \
		--machine-type=e2-micro \
		--subnet=default \
		--network-tier=PREMIUM \
		--metadata=google-logging-enabled=true \
		--tags=http-server,https-server \
		--labels=project=quadquiz

.PHONY: update-instance
update-instance: ## updates image of a running instance
	gcloud compute instances update-container $(instance-name) --container-image gcr.io/duncan-openc2-plugfest/quadquiz:$(image-tag)

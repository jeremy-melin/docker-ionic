.DEFAULT_GOAL := help
.PHONY: trans-pull

# Compose

COMPOSE=docker-compose
RUN_PHRASEAPP=$(COMPOSE) run --rm phraseapp

# Compose CI 

COMPOSE_CI=docker-compose -f docker-compose.ci.yaml
COMPOSE_CI_EXEC=$(COMPOSE_CI) exec -T
COMPOSE_CI_EXEC_CYPRESS=$(COMPOSE_CI_EXEC) cypress

# Bitrise local
RUN_BITRISE_WORKFLOW=bitrise run

build: ## Build docker images
	$(COMPOSE) build

pull-trans:
	$(RUN_PHRASEAPP) phraseapp pull && echo "make pull-trans done"


push-trans:
	$(RUN_PHRASEAPP) phraseapp push

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' 

tests:
	@$(RUN_BITRISE_WORKFLOW) tests

#
# Docker compose CI 
#
dc_ci_up_bg:
	@$(COMPOSE_CI) up -d --build 

dc_ci_up:
	@$(COMPOSE_CI) up --build

dc_ci_down:
	@$(COMPOSE_CI) down

dc_ci_clean:
	@$(COMPOSE_CI) down --rmi all -v

dc_ci_cypress_run:
	@$(COMPOSE_CI_EXEC_CYPRESS) ./scripts/run-cypress-ci.sh
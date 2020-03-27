.DEFAULT_GOAL:=help
SHELL:=/bin/bash

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m***This is the Makefile to start the Walter platform locally***\033[0m \n \nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)



export ENV_FILE=env/staging.env

check: ## check env vars for platform
	 @ ./check_env.sh

kill: ## kill'em all 
	 docker-compose -f docker-compose-cloud.yaml -f docker-compose-local.yaml down

prod: check kill ## running apps locally and prod-db in cloud
	 export ENV_FILE=env/prod.env && echo $$(ENV_FILE);\
	 docker-compose -f docker-compose-cloud.yaml up --build

stag: check kill ## running apps locall and use staging-db in cloud
	 echo $$ENV_FILE 
	 docker-compose -f docker-compose-cloud.yaml up --build

local: kill ## just start all components locally
	 docker-compose -f docker-compose-local.yaml up --build

test: kill ## running tests with all components locally
	 docker-compose -f docker-compose-local.yaml build
	 docker-compose -f docker-compose-local.yaml run test 
	 
cos: ## git checkout staging for all submodules
	 git checkout -B staging origin/staging
	 git submodule update

com: ## git checkout master for all submodules
	 git checkout -B master origin/master
	 git submodule update


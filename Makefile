# Make help the default target
.DEFAULT_GOAL := help

.PHONY: help lint test

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docs: ## Generate README.md on each charts
	@./scripts/helm-docs

lint: ## Lint helm chart
	@./scripts/helm-lint

test: lint ## Test helm chart
	@helm unittest . --helm3

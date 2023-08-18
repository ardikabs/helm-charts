# Make help the default target
.DEFAULT_GOAL := help

.PHONY: help lint test

VERSION=$(shell cat VERSION)

docs: ## Automatically generate documentation
	@sed -i "s|^version: .*|version: $(VERSION)|" Chart.yaml
	@helm-docs

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lint: ## Lint helm chart
	@helm lint

test: lint ## Test helm chart
	@helm unittest . --helm3

publish: ## Publishing helm chart
	@helm package common-app --destination .generated
	@helm repo index .generated --merge .generated/index.yaml --url https://github.com/ardikabs/helm-charts/releases/download/common-app-1.0.0
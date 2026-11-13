# Developer shortcuts for the Olympic Participation Tracker.
# Each target is a thin wrapper: the underlying command is shown next to it,
# and the operations runbook documents the commands without make.

.DEFAULT_GOAL := help
URL ?= http://localhost

.PHONY: help install up down ps logs health test clean

help: ## List the targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-10s %s\n", $$1, $$2}'

install: ## Build the image and start the app (nginx on port 80)
	docker compose up -d --build --wait

up: ## Start the app without rebuilding
	docker compose up -d --wait

down: ## Stop the app
	docker compose down

ps: ## Show the container
	docker compose ps

logs: ## Follow the nginx logs
	docker compose logs -f app

health: ## Check the home page and a deep link are served
	curl -sf -o /dev/null -w "home      %{http_code}\n" $(URL)/
	curl -sf -o /dev/null -w "deep link %{http_code}\n" $(URL)/some/deep/link

test: ## Run the unit tests (reports in test-results/)
	./run-tests.sh

clean: ## Stop the app and remove its local image
	docker compose down --rmi local

.PHONY: setup up down

setup:
	@if [ ! -f .env ]; then \
		echo "creating env" \
		cp .env.example .env; \
	fi

up: setup
	docker compose pull
	docker compose up -d --remove-orphans

down:
	docker compose down

.PHONY: setup up down

setup:
	@if [ ! -f .env ]; then \
		echo "creating env"; \
		cp .env.example .env; \
	fi

up: setup
	docker compose pull
	ALLOY_COLLECT_HOST="true" ALLOY_PROCFS_PATH="/host/proc" ALLOY_SYSFS_PATH="/host/sys" ALLOY_ROOTFS_PATH="/host/root" ALLOY_SYSTEM_TARGETS="null" ALLOY_MOUNT_PROPAGATION="rslave" docker compose up -d --remove-orphans

down:
	docker compose down

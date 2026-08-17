@echo off
echo checking .env
if exist ".env" (
    echo "yurp"
) else (
    echo creating .env file
    copy ".env.example" ".env"
)

echo updating images
docker compose pull

echo starting cluster
set ALLOY_PROCFS_PATH=/proc
set ALLOY_SYSFS_PATH=/sys
set ALLOY_ROOTFS_PATH=/
set ALLOY_SYSTEM_TARGETS=[]
set ALLOY_MOUNT_PROPAGATION=rprivate

docker compose up --build --remove-orphans

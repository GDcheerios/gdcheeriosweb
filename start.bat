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
docker compose up -d --remove-orphans

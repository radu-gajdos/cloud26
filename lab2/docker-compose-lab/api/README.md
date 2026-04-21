# API Service

A Spring Boot REST API backed by PostgreSQL.

## TL;DR

```powershell
# Build the image
docker build -t lab-api .

# Run the container
docker run -p 8080:8080 `
  -e DB_HOST=host.docker.internal `
  -e POSTGRES_DB=appdb `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=password `
  lab-api
```

> **Note:** The above command assumes you have PostgreSQL running locally with the specified credentials. You can adjust the environment variables as needed.

## Useful for debugging

```powershell
# List files inside the container without starting the app (useful on first build)
docker run --rm --entrypoint ls lab-api -la /app

# Open a shell inside the running container to debug
docker exec -it $(docker ps -qf "ancestor=lab-api") /bin/bash
```

> **Note:** `host.docker.internal` lets the container reach services running on your local machine.
> When running via `docker-compose` from the project root, these values are set automatically.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Returns `{"status": "connected"}` |
| GET | `/health` | Returns `{"status": "healthy"}` |
| GET | `/actuator/health` | Spring Boot health details |


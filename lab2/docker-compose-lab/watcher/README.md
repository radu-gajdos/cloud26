# Watcher Service — Part 2 Implementation

This directory is intentionally left for you to implement as part of **Part 2** of the lab.

## Requirements

1. Create a `Dockerfile` that uses a **multi-stage build** to keep the final image small.
2. Implement a watcher script (Go, Node.js, or Shell) that:
   - Pings `http://api:8080/` every 10 seconds.
   - Prints a timestamped log line for each result (success or failure).
3. Add the `watcher` service to `docker-compose.yml` with:
   - A `depends_on` condition of `service_healthy` on the `api` service.
   - The `api` service must define a `healthcheck` for this to work.
4. Move `POSTGRES_PASSWORD` out of the YAML into a `.env` file (copy `.env.example` → `.env`).

## Hints

- For a Shell-based watcher, `wget -q -O- http://api:8080/` or `curl -sf http://api:8080/` works well inside an `alpine` container.
- For multi-stage Go, build in `golang:1.22-alpine` and copy the binary into `scratch` or `alpine`.
- The `healthcheck` in Compose uses the `test`, `interval`, `timeout`, and `retries` keys.
- Spring Boot Actuator exposes a `/actuator/health` endpoint — useful for the healthcheck `test`.

## Example `depends_on` syntax

```yaml
watcher:
  build: ./watcher
  depends_on:
    api:
      condition: service_healthy
```

## Example `healthcheck` for the `api` service

```yaml
api:
  build: ./api
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
    interval: 15s
    timeout: 5s
    retries: 5
    start_period: 30s
```


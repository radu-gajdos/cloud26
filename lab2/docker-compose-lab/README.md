# docker-compose-lab

Lab 2 — Docker Compose: "Black Box" Microservices Debugging

**Objective:** Master `docker-compose` by troubleshooting internal image failures and extending a distributed system.

---

## Summary

A three-tier application consisting of:

- **`api`** — Spring Boot REST API (Java 17, Maven) connected to a PostgreSQL database, exposed on port `8080`
- **`db`** — PostgreSQL 15 database for persistent storage
- **`web`** — Static nginx frontend that communicates with the API, exposed on port `80`

Once the stack is running, the UI can be accessed at **[http://localhost:80](http://localhost:80)** and the API directly at **[http://localhost:8080](http://localhost:8080)**.

The frontend displays a single page with a **"Ping API"** button. Clicking it sends a request to `GET /` on the API and shows the JSON response (`{"status": "connected"}`) in green on success, or an error message in red if the API is unreachable.

---

## TL;DR — Quick Start

```bash

# Clone / open the repo, then:

# Attempt the initial (broken) build:
docker-compose up --build

# Read the error output carefully — it's your first clue.
```

### More Commands

```bash
# Start — build images and run all services in the background
docker-compose up --build -d

# Stop — remove containers and networks (keeps volumes & images)
docker-compose down

# Check that all containers are running
docker-compose ps

# Tail the logs (Ctrl+C to stop following)
docker-compose logs -f

# Pause containers without removing them (keeps volumes & images)
docker-compose stop

# Full teardown — remove containers, networks AND volumes (wipes DB data)
docker-compose down -v
```

---

## Project Structure

```text
.
├── api/
│   ├── Dockerfile                                      
│   ├── pom.xml                                         ← Maven build descriptor
│   └── src/
│       └── main/
│           ├── java/com/lab/api/
│           │   ├── ApiApplication.java
│           │   └── ApiController.java                  ← REST endpoints
│           └── resources/
│               └── application.properties              ← Spring Boot config
├── web/
│   ├── Dockerfile
│   └── index.html          ← static frontend
├── watcher/
│   └── README.md           ← Part 2 stub — you must implement this
├── docker-compose.yml      
├── .env.example            ← copy to .env and fill in secrets
└── README.md
```

---

## 1. Scenario

You have inherited a three-tier application (Frontend, API, Database). The previous developer claimed the build "worked
on their machine," but the stack is currently failing at runtime. You must perform **container debugging** to
get the system operational.


---

## 2. Part 1 — Debugging Task

The stack contains **5 intentional bugs** spread across the Dockerfiles, application code, and Compose file. Your goal
is to identify and fix all of them so that `docker-compose up` runs without errors and the API can communicate with the
Database.

Some hints on how to start:

- try to build the ```api``` service first ( check the README inside the folder) to isolate the issue. You will need to
  fix the docker build before you can run the container. Find the error message displayed at the build and execute into
  the container to check the file system and permissions.
- Once the build is successful, try to run the stack through docker-compose and check the logs of the ```api``` service.
  You will find some
  error messages related to the database connection. Check the configuration in the `application.properties` file and
  compare it with the environment variables defined in the `docker-compose.yml`. You can also check if the database
  container is running and if it is accessible from the api container.
- make sure to have the data persisted in the database container, even after stopping and removing the containers. You
  can achieve this by using docker volumes.

### Useful Diagnostic Commands

```bash
# Watch live logs
docker-compose logs -f api

# Inspect the last exit reason
docker inspect <container_id> --format '{{.State.ExitCode}} {{.State.Error}}'

# Open a shell inside a running container
docker exec -it <container_name> /bin/sh

# Check which user owns /app
docker exec -it <container_name> ls -la /app
```

---

## 3. Part 2 — Implementation Task

Once the stack is stable, add a **Health Monitoring Service** (`watcher`).

### Requirements

1. **New Image:** Implement `watcher/Dockerfile` as a **multi-stage build**.
2. **Language:** Go, Node.js, or a Shell script — your choice.
3. **Functionality:** The watcher must ping `http://api:8080/` every 10 seconds and log the result with a timestamp.
4. **Advanced Compose Features:**
    - Add a `healthcheck` to the `api` service.
    - Configure `watcher` with `depends_on: api: condition: service_healthy`.
    - Move `POSTGRES_PASSWORD` out of the YAML into a `.env` file (use `.env.example` as a template).

See `watcher/README.md` for detailed hints.

---

## 4. Submission Requirements

1. **Corrected Files:** Your updated `docker-compose.yml`, both `Dockerfiles`, `pom.xml`, and `application.properties`.
2. **The Fix Log:** A Markdown table listing each bug, the command you used to diagnose it, and how you fixed it.
3. **Multi-Stage Build:** The `watcher` Dockerfile **must** use a multi-stage build.
4. **`.env` File:** A `.env` file (based on `.env.example`) that supplies the database password at runtime.



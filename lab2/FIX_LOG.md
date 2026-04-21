# Part 1 — Bug Fix Log

| # | File | Bug Description | Diagnostic Command | Fix Applied |
|---|------|-----------------|--------------------|-------------|
| 1 | `api/Dockerfile` | `CMD` referenced `application.jar` but the JAR was copied as `app.jar` — container exited immediately on startup | `docker-compose up --build` → `Error: Unable to access jarfile application.jar` | Changed `CMD ["java", "-jar", "application.jar"]` → `CMD ["java", "-jar", "app.jar"]` |
| 2 | `docker-compose.yml` | `api` service had no `DB_HOST` env var — `application.properties` defaulted to `localhost:5432` instead of the `db` container | `docker-compose logs api` → `Connection refused: localhost/127.0.0.1:5432` | Added `DB_HOST: db` to the `api` environment block |
| 3 | `docker-compose.yml` | `api` had no `depends_on: db` — the API container started before PostgreSQL was ready | `docker-compose logs api` → repeated `Connection refused` errors at boot | Added `depends_on: - db` to the `api` service |
| 4 | `docker-compose.yml` | `db` service had no volume — all data was lost on `docker-compose down` | `docker-compose down && docker-compose up` → empty database every restart | Added named volume `db_data:/var/lib/postgresql/data` and declared it under `volumes:` |
| 5 | `api/pom.xml` | `spring-boot-starter-data-jpa` was missing — `spring.jpa.hibernate.ddl-auto=update` in `application.properties` had no effect and Hibernate was never initialised | `docker-compose logs api` → `JPA / Hibernate auto-configuration skipped` warning | Added `spring-boot-starter-data-jpa` dependency to `pom.xml` |

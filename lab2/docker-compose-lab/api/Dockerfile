FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /build

COPY . .

# Build the fat JAR
RUN mvn package -DskipTests --no-transfer-progress

# ── Runtime stage ────────────────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /build/target/*.jar app.jar

RUN useradd -m developer
USER developer

CMD ["java", "-jar", "app.jar"]

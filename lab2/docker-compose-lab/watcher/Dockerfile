FROM alpine:3.19 AS build

RUN apk add --no-cache curl
COPY watcher.sh /watcher.sh
RUN chmod +x /watcher.sh

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM alpine:3.19

RUN apk add --no-cache curl
COPY --from=build /watcher.sh /watcher.sh

CMD ["/watcher.sh"]

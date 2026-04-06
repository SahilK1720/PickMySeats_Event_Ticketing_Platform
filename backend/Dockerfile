# ----------- Build Stage -----------
FROM rust:slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# Copy everything from backend folder
COPY . .

# Build
RUN cargo build --release


# ----------- Runtime Stage -----------
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/target/release/scantix-backend /app/scantix-backend
COPY --from=builder /app/migrations /app/migrations

EXPOSE 8080

CMD ["./scantix-backend"]
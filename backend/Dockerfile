# ----------- Build Stage -----------
FROM rust:slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# Copy dependency files first (for caching)
COPY Cargo.toml Cargo.lock* ./

# Create dummy main to cache dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true

# Copy actual source code
COPY src/ src/
COPY migrations/ migrations/

# Rebuild with actual code
RUN touch src/main.rs
RUN cargo build --release


# ----------- Runtime Stage -----------
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy compiled binary
COPY --from=builder /app/target/release/scantix-backend /app/scantix-backend

# Copy migrations (if your app uses them at runtime)
COPY --from=builder /app/migrations /app/migrations

# Expose app port
EXPOSE 8080

# Start the app
CMD ["./scantix-backend"]
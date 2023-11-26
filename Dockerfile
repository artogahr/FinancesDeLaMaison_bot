FROM rust:1.74.0 AS builder
RUN apt-get update && apt-get -y install ca-certificates cmake musl-tools libssl-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /prod
COPY Cargo.toml .
RUN mkdir .cargo
# This is the trick to speed up the building process.

COPY . .
RUN cargo build --release

# Use any runner as you want
# But beware that some images have old glibc which makes rust unhappy
FROM fedora:latest AS runner
COPY --from=builder /prod/target/release/finances-bot /bin

CMD ["/bin/finances-bot"]


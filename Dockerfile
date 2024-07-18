FROM rust:1.79 as builder

WORKDIR /app

COPY . .

RUN cargo install --path .

FROM rust:1.79.0-slim

WORKDIR /app

COPY --from=builder /app/target/release/dob-decoder-server /app/dob-decoder-server
COPY --from=builder /app/settings.mainnet.toml /app/settings.toml
COPY --from=builder /app/settings.toml /app/testnet.settings.toml
COPY --from=builder /app/cache/ /app/cache/

RUN mkdir -p /app/cache/decoders && mkdir -p /app/cache/dobs

CMD ["/app/dob-decoder-server"]
# CMD ["/bin/bash", "-c", "mv /app/testnet.settings.toml /app/settings.toml && /app/dob-decoder-server"]

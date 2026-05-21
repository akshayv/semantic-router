# Optional TLS roots for Docker builds

Corporate proxies that inspect HTTPS often break `cargo` and `go` inside Docker.

Place your organization root CA (PEM) here:

```text
build-certs/extra-ca.pem
```

On macOS (often enough for Docker Desktop builds):

```bash
security find-certificate -a -p /Library/Keychains/System.keychain \
  > build-certs/extra-ca.pem
```

## Go-only rebuild (skip cargo)

When only Go router code changed:

```bash
make vllm-sr-dev-go-only
```

This reuses Rust `.so` files from an existing image and rebuilds the router binary only.

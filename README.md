# Tesla Android

[![Tests](https://img.shields.io/badge/tests-340%20passing-success)](test/README.md)
[![Coverage](https://img.shields.io/badge/coverage-80.1%25-success)](coverage/html/index.html)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.35.0-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Flutter app for Tesla Android.

Please refer to [teslaandroid.com](https://teslaandroid.com) for release notes, hardware requirements, and the install guide.

## Quick Start

```bash
# Install app dependencies
make install

# Install mock backend dependencies
make install-mock-deps

# Start mock server (in a separate terminal)
make mock-server

# Run app (mock mode)
make run-mock

# Run tests
make test

# Generate coverage
make coverage
```

See [`Makefile`](Makefile) for all available commands.

## Development

**Test guide**: [`test/README.md`](test/README.md)

**Mock backend**: [`docs/MOCK_BACKEND.md`](docs/MOCK_BACKEND.md)

## Hardware Debugging

When connecting to real Tesla Android hardware:
1. Connect to Tesla Android Wi-Fi network
2. Disable CORS in Chrome

## Please Consider Supporting the Project

[Donations](https://teslaandroid.com/donations)

.PHONY: help test test-watch coverage gen clean analyze format quick-check install run run-mock build

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Development
install: ## Install dependencies
	flutter pub get
	flutter packages pub run build_runner build --delete-conflicting-outputs

run: ## Run app in Chrome
	flutter run -d chrome --web-port=8080

run-mock: ## Run app with mock backend
	@echo "Starting app in Mock Mode..."
	flutter run -d chrome --web-port=8080 --dart-define=MOCK_MODE=true

mock-server: ## Run the mock backend server
	python3 tools/mock_backend/mock_backend.py

install-mock-deps: ## Install dependencies for mock backend
	pip3 install aiohttp aiohttp-cors websockets

# Testing
test: ## Run all tests
	flutter test

test-watch: ## Run tests in watch mode
	flutter test --watch

coverage: ## Generate coverage report and open in browser
	flutter test --coverage
	@if command -v genhtml > /dev/null; then \
		genhtml coverage/lcov.info -o coverage/html -q; \
		open coverage/html/index.html || xdg-open coverage/html/index.html; \
	else \
		echo "genhtml not found. Install lcov: brew install lcov (macOS) or apt-get install lcov (Linux)"; \
	fi

# Code Generation
gen: ## Run build_runner code generation
	flutter packages pub run build_runner build --delete-conflicting-outputs

gen-watch: ## Watch for changes and regenerate code
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# Code Quality
analyze: ## Run static analysis
	flutter analyze

format: ## Format code
	dart format lib/ test/

format-check: ## Check code formatting
	dart format --set-exit-if-changed lib/ test/

# Combined Tasks
quick-check: format analyze test ## Run format, analyze, and tests

pre-commit: format-check analyze test ## Pre-commit checks (fails on format issues)

# Cleanup
clean: ## Clean build artifacts
	flutter clean
	rm -rf coverage/

clean-all: clean ## Clean everything including dependencies
	rm -rf .dart_tool/
	rm -rf build/
	rm -f pubspec.lock

reset: clean-all install ## Full reset: clean and reinstall

# Build
build: ## Build web app for production
	flutter build web

build-profile: ## Build web app in profile mode
	flutter build web --profile

# Other
doctor: ## Check Flutter installation
	flutter doctor -v

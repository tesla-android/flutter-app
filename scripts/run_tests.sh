#!/bin/bash
# Test runner script for Tesla Android Flutter app
# Runs different test suites based on environment

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Tesla Android Test Runner${NC}"
echo "================================"
echo ""

# Function to run VM tests (fast)
run_vm_tests() {
    echo -e "${YELLOW}Running All Tests in VM${NC}"
    # Runs all tests found in the test/ directory
    # This includes unit, widget, and integration tests
    flutter test
    
    echo -e "${GREEN}✓ VM Tests Complete${NC}"
}

# Function to run browser tests (slower)
run_browser_tests() {
    echo -e "${YELLOW}Running Unit Tests in Chrome${NC}"
    # Runs unit tests on Chrome to verify web compatibility
    # Note: Widget and Integration tests are skipped to save time/avoid io dependencies
    flutter test --platform chrome test/unit/
    
    echo -e "${GREEN}✓ Browser Tests Complete${NC}"
}

# Function to run all tests
run_all_tests() {
    # Default to just VM tests as they cover the codebase 
    # and are significantly faster.
    run_vm_tests
}

# Parse command line arguments
case "${1:-all}" in
    vm)
        run_vm_tests
        ;;
    browser)
        run_browser_tests
        ;;
    all)
        run_all_tests
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        echo "Usage: $0 {vm|browser|all}"
        echo ""
        echo "  vm      - Run fast VM tests (all tests)"
        echo "  browser - Run unit tests in Chrome"
        echo "  all     - Run all standard tests (currently alias for vm)"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Test execution completed successfully!${NC}"

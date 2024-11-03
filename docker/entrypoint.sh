#!/bin/bash

# Define variables for the test directory and main script path
TEST_DIR="/app/tests"
SCRIPT_PATH="/app/shellm"

# Check if --watch flag is provided
WATCH_MODE=false
if [[ "$1" == "--watch" ]]; then
    WATCH_MODE=true
fi

# Function to run all tests
run_tests() {
    echo "Running BATS tests..."
    if [ -d "$TEST_DIR" ]; then
        /usr/local/bin/bats -r "$TEST_DIR"
    else
        echo "No tests found in $TEST_DIR."
        exit 1
    fi
}

# Run tests initially
run_tests

# If watch mode is enabled, use inotifywait to monitor for changes
if $WATCH_MODE; then
    echo "Watching $SCRIPT_PATH for changes..."
    # Loop to rerun tests when changes are detected
    while inotifywait -q -e modify "$SCRIPT_PATH"; do
        echo "Detected changes in $SCRIPT_PATH. Rerunning tests..."
        run_tests
    done
fi

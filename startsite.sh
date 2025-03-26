#!/bin/bash

# Author: antoniohg (https://github.com/antoniohg)
# Description: Start to develop a site with npm run dev, open the project in Visual Studio Code, and open the site in the browser
# Dependencies: npm, Visual Studio Code (code), and a browser (Google Chrome)
# Usage: startsite [directory]
#   directory: The project directory to open (default: .)

start_site() {
  # Use the first argument as the project directory, or the current directory
  PROJECT_DIR=${1:-$(pwd)}

  # Verify that the project directory exists
  if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: $PROJECT_DIR does not exist"
    exit 1
  fi

  echo "📂 Project: $PROJECT_DIR"

  # Change to the project directory
  cd "$PROJECT_DIR" || { echo "❌ No se pudo acceder a $PROJECT_DIR"; exit 1; }

  # Open the project in Visual Studio Code (using full path instead of alias to avoid issues with the shell)
  open -a "Visual Studio Code" .

  # Manage interruption with SIGINT (Ctrl + C)
  trap cleanup SIGINT
  cleanup() {
    echo "🛑 Deteniendo servidor..."
    kill "$SERVER_PID" 2>/dev/null
    exit 0
  }

  # Start the server in the background and log the output with the original colors (using tee to capture the logs), ignoring the EIO error when stopping the server
  start_server() {
    echo "⏳ Starting the server..."
    FORCE_COLOR=1 npm run dev --color=always | tee /tmp/server.log || true &
    SERVER_PID=$!
  }

  # Wait for the server to start and check the logs for the port number
  wait_for_server() {
    echo "⏳ Waiting for the server to start..."
    while true; do
      if grep -q "ready" /tmp/server.log; then
        extract_port
        if [ -n "$PORT" ]; then
          echo "✅ Server started at http://localhost:$PORT/"
          open_browser "http://localhost:$PORT/"
          break
        else
          echo "⚠️ Could not find the port number in the logs, retrying..."
        fi
      fi
      echo "⏳ Waiting..."
      sleep 1
    done
  }

  # Extract the port number from the server logs
  extract_port() {
    PORT=$(grep -oE "http://localhost:[0-9]+" /tmp/server.log | head -n 1 | cut -d':' -f3)
  }

  # Open the browser to the specified URL
  open_browser() {
    URL=$1
    echo "Opening browser to: $URL"
    open -b com.google.Chrome "$URL"
  }

  # Start the server and wait for it to be ready
  start_server
  wait_for_server

  # Wait for the server to finish (this will block until the server stops)
  wait "$SERVER_PID"
}

# Execute the function and pass it the first argument
start_site "$1"

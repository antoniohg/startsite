#!/bin/bash

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

  # Open the project in Visual Studio Code
  code .

  # Manage interruption with SIGINT (Command + C)
  trap cleanup SIGINT
  cleanup() {
    echo "🛑 Deteniendo servidor..."
    kill "$SERVER_PID" 2>/dev/null
    exit 0
  }

  echo "⏳ Starting the server..."

  # Start the server in the background and log the output with the original colors (using tee to capture the logs), ignoring the EIO error when stopping the server

  FORCE_COLOR=1 npm run dev --color=always | tee /tmp/server.log || true &
  SERVER_PID=$!

  # Wait for the server to start
  echo "⏳ Waiting for the server to start..."
  sleep 2

  PORT=$(grep -oE "http://localhost:[0-9]+" /tmp/server.log | head -n 1 | cut -d':' -f3)
  if [ -n "$PORT" ]; then
    echo "✅ Server started at http://localhost:$PORT/"
    open -b com.google.Chrome "http://localhost:$PORT/"
  else
    echo "⚠️ Could not find the port number in the logs"
  fi

  wait "$SERVER_PID"
}

# Execute the function and pass it the first argument
start_site "$1"

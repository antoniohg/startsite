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

  # Start the server in the background and log the output with the original colors
  FORCE_COLOR=1 npm run dev --color=always | tee /tmp/site.log || true &

  # Wait for the server to start
  echo "⏳ Waiting for the server to start..."
  sleep 2

  # Extract the port number from the logs
  PORT=$(grep -oE "http://localhost:[0-9]+" /tmp/site.log | head -n 1 | cut -d":" -f3)

  if [ -n "$PORT" ]; then
    echo "✅ Server started at http://localhost:$PORT"
    # Open the site in Chrome
    open -b com.google.Chrome "http://localhost:$PORT/"
    echo "🌐 Site opened in Chrome."
  else
    echo "⚠️ Could not find the port number in the logs"
    echo "⏹️ Exiting..."
    exit 1
  fi
}

# Ejecutar la función y pasarle el primer argumento
start_site "$1"

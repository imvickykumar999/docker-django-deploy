#!/bin/bash

echo "🚫 Searching for zombie Docker containers (Django/Playit)..."

# Dynamically find container names containing 'django' or 'playit'
CONTAINERS=$(docker ps -a --format '{{.Names}}' | grep -E 'django|playit')

if [ -z "$CONTAINERS" ]; then
    echo "✅ No Django or Playit containers found."
else
    for name in $CONTAINERS; do
        PID=$(docker inspect --format '{{ .State.Pid }}' "$name" 2>/dev/null)

        if [ -n "$PID" ] && [ "$PID" -ne 0 ]; then
            echo "🧟 Killing container '$name' (PID: $PID)..."
            sudo kill -9 "$PID" || echo "⚠️ Failed to kill PID $PID"
        fi

        echo "🗑️ Removing container '$name'..."
        sudo docker rm -f "$name" || echo "⚠️ Failed to remove $name"
    done
fi

echo "🔻 Running docker-compose down just in case..."
sudo docker-compose down || echo "⚠️ docker-compose down failed"

echo "✅ Cleanup complete. All containers shut down cleanly."

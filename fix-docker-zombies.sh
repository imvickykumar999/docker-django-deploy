#!/bin/bash

echo "🚫 Killing zombie Docker containers (if any)..."

CONTAINERS=("project-django-1" "project-playit-1")

for name in "${CONTAINERS[@]}"; do
    if docker ps -a --format '{{.Names}}' | grep -q "^$name$"; then
        PID=$(docker inspect --format '{{ .State.Pid }}' "$name" 2>/dev/null)
        if [ -n "$PID" ] && [ "$PID" -ne 0 ]; then
            echo "🧟 Killing $name (PID: $PID)"
            sudo kill -9 "$PID"
        fi
        echo "🗑️ Removing $name"
        sudo docker rm -f "$name"
    else
        echo "✅ Container $name not found or already removed."
    fi
done

echo "🔻 Running docker-compose down just in case..."
docker-compose down

echo "✅ All containers shut down cleanly."

#!/bin/bash

CONTAINER_NAME="local-ollama"
MODEL_NAME="qwen3.6:27b"

case "$1" in
  start)
    echo "▶️  Starting Ollama container..."
    
    # Check if the container already exists
    if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
        # Check if it is currently stopped
        if [ "$(docker ps -aq -f status=exited -f name=^/${CONTAINER_NAME}$)" ]; then
            docker start $CONTAINER_NAME
            echo "✅ Container restarted."
        else
            echo "✅ Container is already running."
        fi
    else
        # Spin up a brand new container
        echo "Spinning up fresh GPU-accelerated container..."
        docker run -d \
          --name $CONTAINER_NAME \
          --gpus=all \
          -p 11434:11434 \
          -v ollama-weights:/root/.ollama \
          -e OLLAMA_NUM_CTX=32768 \
          ollama/ollama
    fi

    # Use 'pull' instead of 'run' so it downloads without starting an interactive chat
    echo "⬇️  Verifying model '$MODEL_NAME' is downloaded (this is instant if already cached)..."
    docker exec $CONTAINER_NAME ollama pull $MODEL_NAME
    
    echo "🚀 Ready! Your local LLM is online at http://127.0.0.1:11434"
    ;;
    
  stop)
    echo "⏸️  Stopping Ollama container..."
    docker stop $CONTAINER_NAME
    echo "🛑 Container stopped and GPU VRAM freed."
    ;;
    
  status)
    docker ps -a -f name=^/${CONTAINER_NAME}$
    ;;
    
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
esac

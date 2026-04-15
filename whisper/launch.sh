#!/bin/bash
# Whisper Assistant server launcher for VS Code whisper-assistant extension
# Requires: faster-whisper or compatible server at port 4444
# See: https://github.com/martinopensky/whisper-assistant

set -e

PORT=4444
MODEL="${WHISPER_MODEL:-large-v3}"
DEVICE="${WHISPER_DEVICE:-cuda}"

echo "Starting Whisper server on port $PORT (model: $MODEL, device: $DEVICE)..."

# Adjust the path to wherever whisper server is installed
python3 -m whisper_online_server \
  --port "$PORT" \
  --model "$MODEL" \
  --device "$DEVICE" \
  --language ja

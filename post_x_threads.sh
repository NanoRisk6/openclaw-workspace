#!/usr/bin/env bash

# This script reads the X-thread variants and outputs them ready to post.

HYPE_FILE="clips/x_thread_hype.txt"
PHILOSOPHICAL_FILE="clips/x_thread_philosophical.txt"

if [[ -f "$HYPE_FILE" ]]; then
  echo "\n--- Hype Thread ---"
  cat "$HYPE_FILE"
fi

if [[ -f "$PHILOSOPHICAL_FILE" ]]; then
  echo "\n--- Philosophical Thread ---"
  cat "$PHILOSOPHICAL_FILE"
fi

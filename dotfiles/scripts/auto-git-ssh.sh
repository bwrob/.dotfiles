#!/bin/bash

# Check if ssh-agent is running
if pgrep ssh-agent > /dev/null; then
  echo "ssh-agent already running"
else
  # Start ssh-agent in background
  eval `ssh-agent -s`
fi

# Get optional SSH key path from argument
key_path="${1:-./klucze_ssh/id_ec25519}"

# Add existing SSH key to the agent
ssh-add "$key_path"

echo "SSH agent started and key added"

ssh git@gitlab.com
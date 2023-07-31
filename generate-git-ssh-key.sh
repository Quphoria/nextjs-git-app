#!/bin/sh

# check key comment set
if [ -z "$1" ]; then
  echo "Missing key comment"
  exit 1
fi

ssh-keygen -t ed25519 -C "$1" -P "" -f id_git
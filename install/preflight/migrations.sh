#!/bin/bash

OMARCHY_MIGRATIONS_STATE_PATH=~/.local/state/calos/migrations
mkdir -p $OMARCHY_MIGRATIONS_STATE_PATH

for file in ~/.local/share/omarchy/migrations/*.sh; do
  touch "$OMARCHY_MIGRATIONS_STATE_PATH/$(basename "$file")"
done

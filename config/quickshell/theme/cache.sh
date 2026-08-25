#!/usr/bin/env bash

CONFIG="$1/config.json"

theme_path=$(jq -r '.theme_path' "$CONFIG")
cache_path=$(jq -r '.cache_path' "$CONFIG")
cache_batch_size=$(jq -r '.cache_batch_size' "$CONFIG")

mkdir -p "$cache_path"

echo "Theme path: $theme_path"
echo "Cache path: $cache_path"

for theme in "$theme_path"/*/; do
  [ -d "$theme" ] || continue

  theme_name=$(basename "$theme")
  img="$theme/preview.png"
  out="$cache_path/$theme_name.png"

  [ -f "$img" ] || continue

  if [[ -f "$out" && "$out" -nt "$img" ]]; then
    continue
  fi

  echo "Generating thumbnail for $theme_name"

  convert "$img" \
    -thumbnail x750 \
    -strip \
    -quality 85 \
    "$out" &

  if ((cache_batch_size > 0)); then
    while (($(jobs -rp | wc -l) >= cache_batch_size)); do
      wait -n
    done
  fi
done

wait

echo "Theme thumbnail generation complete."

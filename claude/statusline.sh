#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')

# Get current_usage (tokens in current context window)
current_usage=$(echo "$input" | jq '.context_window.current_usage')

# Calculate total tokens and percentage from current context (not cumulative session totals)
if [ "$current_usage" != "null" ]; then
  # Sum all tokens in current context: input + cache_creation + cache_read
  current_tokens=$(echo "$current_usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  total_tokens=$current_tokens
  percent=$(awk "BEGIN {printf \"%.0f\", ($total_tokens / $context_size) * 100}")
else
  # No messages yet in session
  total_tokens=0
  percent=0
fi

# Format tokens in thousands (e.g., 12345 -> 12k)
tokens_k=$(awk "BEGIN {printf \"%.0f\", $total_tokens / 1000}")

# Create progress bar
bar_length=10
filled=$(awk "BEGIN {printf \"%.0f\", ($percent / 100) * $bar_length}")
empty=$((bar_length - filled))

# Select color based on percentage using discrete steps
if [ "$percent" -le 20 ]; then
  r=0; g=128; b=128
elif [ "$percent" -le 30 ]; then
  r=112; g=164; b=148
elif [ "$percent" -le 40 ]; then
  r=180; g=200; b=168
elif [ "$percent" -le 50 ]; then
  r=246; g=237; b=189
elif [ "$percent" -le 60 ]; then
  r=237; g=187; b=138
elif [ "$percent" -le 70 ]; then
  r=222; g=138; b=90
else
  r=202; g=86; b=44
fi

# Build progress bar with color
bar=""
for ((i=0; i<filled; i++)); do
  bar+="█"
done
for ((i=0; i<empty; i++)); do
  bar+="░"
done
bar+=""

# Format and output with colors
printf "\033[36m%s\033[0m | \033[38;2;%d;%d;%dm%s\033[0m \033[38;2;%d;%d;%dm%sk\033[0m | \033[33m%s\033[0m" \
  "$model" "$r" "$g" "$b" "$bar" "$r" "$g" "$b" "$tokens_k" "$cwd"

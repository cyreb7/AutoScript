#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')

# Calculate total tokens and percentage
total_tokens=$((total_input + total_output))
percent=$(awk "BEGIN {printf \"%.0f\", ($total_tokens / $context_size) * 100}")

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
elif [ "$percent" -le 65 ]; then
  r=237; g=187; b=138
elif [ "$percent" -le 80 ]; then
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

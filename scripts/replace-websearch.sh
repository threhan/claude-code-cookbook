#!/bin/bash

# Read the input JSON from stdin
input_json=$(cat)

# Extract the tool name
tool_name=$(echo "$input_json" | jq -r '.tool_name // empty')

# Check if the tool is web_fetch
if [ "$tool_name" != "web_fetch" ]; then
  # Not the target tool, so just pass the input through
  echo "$input_json"
  exit 0
fi

# Extract the prompt from the web_fetch tool input
web_fetch_prompt=$(echo "$input_json" | jq -r '.tool_input.prompt // empty')

if [ -z "$web_fetch_prompt" ]; then
    # If the prompt is empty, pass it through.
    echo "$input_json"
    exit 0
fi

# Construct the new command for the run_shell_command tool
new_command="gemini --prompt \"WebSearch: $web_fetch_prompt\""
new_description="Replacing disabled WebSearch with Gemini CLI search."

# Create the new JSON output for the run_shell_command tool
new_tool_input=$(jq -n --arg cmd "$new_command" --arg desc "$new_description" \
  '{command: $cmd, description: $desc}')

# Replace the tool_name and tool_input in the original JSON
modified_json=$(echo "$input_json" | jq \
  --argjson new_input "$new_tool_input" \
  '.tool_name = "run_shell_command" | .tool_input = $new_input')

# Output the modified JSON to replace the original tool call
echo "$modified_json"

exit 0

#!/bin/bash

# 读取 JSON 输入，并提取命令和工具名称
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null || echo "")
tool_name=$(echo "$input" | jq -r '.tool_name' 2>/dev/null || echo "")

# 仅检查 Bash 命令
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# 从 settings.json 读取拒绝模式
settings_file="$HOME/.claude/settings.json"

# 获取所有 Bash 命令的拒绝模式
deny_patterns=$(jq -r '.permissions.deny[] | select(startswith("Bash(")) | gsub("^Bash\\("; "") | gsub("\\)$"; "")' "$settings_file" 2>/dev/null)

# 检查命令是否匹配拒绝模式的函数
matches_deny_pattern() {
  local cmd="$1"
  local pattern="$2"

  # 删除开头和结尾的空格
  cmd="${cmd#"${cmd%%[![:space:]]*}"}" # 删除开头的空格
  cmd="${cmd%"${cmd##*[![:space:]]}
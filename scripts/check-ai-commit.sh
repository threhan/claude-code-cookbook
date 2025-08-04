#!/bin/bash

# AI 签名检查脚本
# 如果 git commit 命令中包含 AI 签名，则报错

# 使用 jq 解析 Bash 工具的输入
COMMAND=$(jq -r '.tool_input.command')

# 检查是否为 git commit 命令
if echo "$COMMAND" | grep -q '^git commit'; then
  # 检查是否包含 AI 签名
  if echo "$COMMAND" | grep -q '🤖 Generated with'; then
    echo "Error: 提交信息中包含 AI 签名" >&2
    echo "请删除 AI 签名后重新提交" >&2
    exit 2
  fi
fi

# 如果没有问题则成功
exit 0

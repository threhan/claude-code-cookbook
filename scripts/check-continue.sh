#!/bin/bash

# 简单继续检查
# 如果没有口令，则提示“请继续工作”
#
# 口令是在 CLAUDE.md 中定义的完成时的固定短语
# 详情请参阅：~/.claude/CLAUDE.md 的“工作完成报告规则”

COMPLETION_PHRASE="May the Force be with you."

# 从 Stop hook 读取传入的 JSON
input_json=$(cat)

# 在 Windows 上，JSON 中的反斜杠路径需要特殊处理。
# 为了彻底避免 shell 的转义问题，我们使用 Python 来解析 JSON 并修复路径。
# 这比任何 shell/jq/sed 组合都更稳健。
py_script='import sys, json; data = json.load(sys.stdin); print(data.get("transcript_path", "").replace("\\", "/"))'
transcript_path=$(printf "%s" "$input_json" | python -c "$py_script")
LOG_FILE="F:/git/claude-code-cookbook/check-continue-debug.log"
echo "--- check-continue.sh execution started at $(date) --- " >> "$LOG_FILE" 
echo "py_script"  >> "$LOG_FILE"
echo "$py_script"  >> "$LOG_FILE" 
echo "input_json"  >> "$LOG_FILE"
echo "$input_json"  >> "$LOG_FILE" 
echo "transcript_path"  >> "$LOG_FILE" 
echo "$transcript_path"  >> "$LOG_FILE" 
echo "[ -n "$transcript_path" ]"  >> "$LOG_FILE" 
echo "[ -f "$transcript_path" ]"  >> "$LOG_FILE" 
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # 获取最后一条消息的全部内容（包括错误消息）
  echo "last_entry"  >> "$LOG_FILE" 
  last_entry=$(tail -n 1 "$transcript_path")
  echo "$last_entry"  >> "$LOG_FILE"
  # 为了避免 jq 和 shell 的转义问题，我们继续使用 Python 来解析 last_entry 的各个字段。
  py_script_msg='import sys, json; data=json.load(sys.stdin); print(data.get("message", {}).get("content", [{}])[0].get("text", ""))'
  py_script_err='import sys, json; data=json.load(sys.stdin); print(data.get("message", {}).get("error") or data.get("error", ""))'
  py_script_full='import sys, json; data=json.load(sys.stdin); print(json.dumps(data))'

  # 获取助手消息的文本
  last_message=$(printf "%s" "$last_entry" | python -c "$py_script_msg" 2>/dev/null || echo "")
  echo "last_message think"  >> "$LOG_FILE" 
  echo "$last_message"  >> "$LOG_FILE" 
  # 移除 <think> 标签及其包含的所有内容，以避免其干扰后续的文本匹配
  # 使用 Python 的 re 模块进行多行、不区分大小写的替换，这比 sed 更稳健
  py_script_think='import sys, re; text = sys.stdin.read(); print(re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL | re.IGNORECASE))'
  last_message=$(printf "%s" "$last_message" | python -c "$py_script_think")

  # 检查各种可能的错误字段
  error_message=$(printf "%s" "$last_entry" | python -c "$py_script_err" 2>/dev/null || echo "")

  # 将整个条目字符串化并检查（无论 JSON 结构如何）
  full_entry_text=$(printf "%s" "$last_entry" | python -c "$py_script_full" 2>/dev/null || echo "$last_entry")
  
   
  echo "last_message"  >> "$LOG_FILE" 
  echo "$last_message"  >> "$LOG_FILE" 
  echo "error_message"  >> "$LOG_FILE"
  echo "$error_message"  >> "$LOG_FILE"
  echo "full_entry_text"  >> "$LOG_FILE" 
  echo "$full_entry_text"  >> "$LOG_FILE"
  
  echo "error_message1"  >> "$LOG_FILE" 
  echo "$error_message" | "$error_message" | grep -qi "usage limit" >> "$LOG_FILE" 
  # 检查 Claude usage limit reached（多种方式）
  if echo "$error_message" | grep -qi "usage limit" ||
    echo "$last_message" | grep -qi "usage limit" ||
    echo "$full_entry_text" | grep -qi "usage limit"; then
    # 如果是 Usage limit 错误，则不执行任何操作（正常退出）
    exit 0
  fi
  echo "error_message2"  >> "$LOG_FILE" 
  echo "$error_message" | "$error_message" | grep -qi "usage limit" >> "$LOG_FILE" 
  # 检测其他错误模式
  if echo "$error_message" | grep -qi "network error\|timeout\|connection refused" ||
    echo "$full_entry_text" | grep -qi "network error\|timeout\|connection refused"; then
    # 如果是网络错误，则不执行任何操作（正常退出）
    exit 0
  fi
  echo "error_message3"  >> "$LOG_FILE" 
  # 检测与 /compact 相关的模式（作为错误消息处理）
  if echo "$error_message" | grep -qi "Context low.*Run /compact to compact" ||
    echo "$full_entry_text" | grep -qi "Context low.*Run /compact to compact"; then
    # 如果是与 /compact 相关的消息，则不执行任何操作（正常退出）
    exit 0
  fi
   echo "error_message4"  >> "$LOG_FILE" 
  # 检测 Stop hook feedback 的重复模式
  if echo "$last_message" | grep -qi "Stop hook feedback" &&
    echo "$last_message" | grep -qi "请继续工作"; then
    # 如果是 Stop hook feedback 的重复模式，则不执行任何操作（正常退出）
    exit 0
  fi

  # 检查与计划提议相关的模式（修改：如果已批准则继续）
  if echo "$last_message" | grep -qi "User approved Claude's plan" ||
    echo "$full_entry_text" | grep -qi "User approved Claude's plan"; then
    # 计划已批准 → 继续工作（不阻塞）
    exit 0
  fi
 echo "error_message5"  >> "$LOG_FILE" 
  # 如果被要求使用 y/n 确认
  if echo "$last_message" | grep -qi "y/n" ||
    echo "$full_entry_text" | grep -qi "y/n"; then
    # 计划已批准 → 继续工作（不阻塞）
    exit 0
  fi
  echo "error_message6"  >> "$LOG_FILE" 
  echo "grep -qi 'spec'"  >> "$LOG_FILE" 
  echo "error_message7"  >> "$LOG_FILE" 
  echo "grep -qi 'spec-driven'"  >> "$LOG_FILE" 
  echo "error_message8"  >> "$LOG_FILE" 
  echo "grep -qi 'requirements\.md\\|design\.md\\|tasks\.md'"  >> "$LOG_FILE" 
  # 检查与 /spec 相关的工作模式
  if echo "$last_message" | grep -qi "spec" ||
    echo "$last_message" | grep -qi "spec-driven" ||
    echo "$last_message" | grep -qi "requirements\.md\\|design\.md\\|tasks\.md"; then
    # 在进行与 /spec 相关的工作时，不提示继续（正常退出）
    exit 0
  fi
  echo "last_message"  >> "$LOG_FILE" 
  echo "$last_message" >> "$LOG_FILE" 
  echo "grep" >> "$LOG_FILE" 
  echo "$last_message" | grep -q "$COMPLETION_PHRASE" >> "$LOG_FILE" 
  # 检查口令
  # 使用 grep -F 进行固定字符串搜索，并直接检查 full_entry_text，因为它包含了所有可能出现的文本。
  if echo "$last_message" | grep -qF "$COMPLETION_PHRASE"; then
    # 如果有口令，则不执行任何操作（正常退出）
    exit 0
  fi
fi

# 如果没有口令，则提示继续
cat <<EOF
{
  "decision": "block",
  "reason": "请继续工作。\n  如果没有要继续的工作，请输入 \`$COMPLETION_PHRASE\` 来结束。"
}
EOF

## 问题列表

按优先级显示当前仓库的开放问题列表。

### 使用方法

```bash
# 请求 Claude
“请按优先级显示开放问题列表”
```

### 基本示例

```bash
# 获取仓库信息
gh repo view --json nameWithOwner | jq -r '.nameWithOwner'

# 获取开放问题信息并请求 Claude
gh issue list --state open --json number,title,author,createdAt,updatedAt,labels,assignees,comments --limit 30

“请按优先级整理上述问题，并显示每个问题的两行摘要。请使用上面获取的仓库名称生成 URL”
```

### 显示格式

```
开放问题列表（按优先级排序）

### 高优先级
#编号 标题 [标签] | 作者 | 自开放以来的时间 | 评论数 | 负责人
      ├─ 摘要第一行
      └─ 摘要第二行
      https://github.com/owner/repo/issues/编号

### 中优先级
（格式同上）

### 低优先级
（格式同上）
```

### 优先级判断标准

**高优先级**

- 带有 `bug` 标签的问题
- 带有 `critical` 或 `urgent` 标签的问题
- 带有 `security` 标签的问题

**中优先级**

- 带有 `enhancement` 标签的问题
- 带有 `feature` 标签的问题
- 已分配负责人的问题

**低优先级**

- 带有 `documentation` 标签的问题
- 带有 `good first issue` 标签的问题
- 带有 `wontfix` 或 `duplicate` 标签的问题

### 按标签筛选

```bash
# 仅获取特定标签的问题
gh issue list --state open --label "bug" --json number,title,author,createdAt,labels,comments --limit 30

# 使用多个标签进行筛选（AND 条件）
gh issue list --state open --label "bug,high-priority" --json number,title,author,createdAt,labels,comments --limit 30
```

### 注意事项

- 需要 GitHub CLI (`gh`)
- 仅显示开放状态的问题
- 最多显示 30 个问题
- 经过时间是指问题开放以来的时间
- 问题的 URL 是根据实际仓库名称自动生成的
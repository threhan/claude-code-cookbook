## PR 列表

按优先级显示当前仓库的开放 PR 列表。

### 使用方法

```bash
# 请求 Claude
“请按优先级显示开放 PR 列表”
```

### 基本示例

```bash
# 获取仓库信息
gh repo view --json nameWithOwner | jq -r '.nameWithOwner'

# 获取开放 PR 信息并请求 Claude
gh pr list --state open --draft=false --json number,title,author,createdAt,additions,deletions,reviews --limit 30

“请按优先级整理上述 PR，并显示每个 PR 的两行摘要。请使用上面获取的仓库名称生成 URL”
```

### 显示格式

```
开放 PR 列表（按优先级排序）

### 高优先级
#编号 标题 [Draft/DNM] | 作者 | 自开放以来的时间 | Approved 数量 | +添加/-删除
      ├─ 摘要第一行
      └─ 摘要第二行
      https://github.com/owner/repo/pull/编号

### 中优先级
（格式同上）

### 低优先级
（格式同上）
```

### 优先级判断标准

**高优先级**

- `fix:` 错误修复
- `release:` 发布工作

**中优先级**

- `feat:` 新功能
- `update:` 功能改进
- 其他常规 PR

**低优先级**

- 包含 DO NOT MERGE 的 PR
- Draft 状态的 `test:`、`build:`、`perf:` PR

### 注意事项

- 需要 GitHub CLI (`gh`)
- 仅显示开放状态的 PR（不包括 Draft）
- 最多显示 30 个 PR
- 经过时间是指 PR 开放以来的时间
- PR 的 URL 是根据实际仓库名称自动生成的
## PR 创建

通过基于 Git 变更分析的自动 PR 创建，实现高效的 Pull Request 工作流。

### 使用方法

```bash
# 通过变更分析自动创建 PR
git add . && git commit -m "feat: 实现用户认证功能"
“请分析变更内容，并使用适当的描述和标签创建 Draft PR”

# 在保留现有模板的情况下更新
cp .github/PULL_REQUEST_TEMPLATE.md pr_body.md
“请完全保留模板结构，并补充变更内容”

# 分阶段提高质量
gh pr ready
“质量确认完成后，请将状态更改为 Ready for Review”
```

### 基本示例

```bash
# 1. 创建分支并提交
git checkout main && git pull
git checkout -b feat-user-profile
git add . && git commit -m "feat: 实现用户个人资料功能"
git push -u origin feat-user-profile

# 2. 创建 PR
“请按以下步骤创建 PR：
1. 使用 git diff --cached 确认变更内容
2. 使用 .github/PULL_REQUEST_TEMPLATE.md 创建描述
3. 从变更内容中选择最多 3 个适当的标签
4. 作为 Draft PR 创建（保留 HTML 注释）”

# 3. CI 通过后设为 Ready
“CI 通过后，请将 PR 状态更改为 Ready for Review”
```

### 执行步骤

#### 1. 创建分支

```bash
# 遵循指南的命名规则: {type}-{subject}
git checkout main
git pull
git checkout -b feat-user-authentication

# 确认分支（显示当前分支名称）
git branch --show-current
```

#### 2. 提交

```bash
# 暂存变更
git add .

# 遵循指南的提交信息
git commit -m "feat: 实现用户认证 API"
```

#### 3. 推送到远程仓库

```bash
# 首次推送（设置上游）
git push -u origin feat-user-authentication

# 第二次及以后
git push
```

#### 4. 通过自动分析创建 Draft PR

**步骤 1: 分析变更内容**

```bash
# 获取文件变更（确认已暂存的变更）
git diff --cached --name-only

# 内容分析（最多 1000 行）
git diff --cached | head -1000
```

**步骤 2: 自动生成描述**

```bash
# 模板处理优先级
# 1. 现有 PR 描述（完全保留）
# 2. .github/PULL_REQUEST_TEMPLATE.md
# 3. 默认模板

cp .github/PULL_REQUEST_TEMPLATE.md pr_body.md
# 在保留 HTML 注释和分隔线的情况下，仅补充空的部分
```

**步骤 3: 自动选择标签**

```bash
# 获取可用标签（非交互式）
“请从 .github/labels.yml 或 GitHub 仓库获取可用标签，并根据变更内容自动选择适当的标签”

# 通过模式匹配自动选择（最多 3 个）
# - 文档: *.md, docs/ → documentation|docs
# - 测试: test, spec → test|testing
# - 错误修复: fix|bug → bug|fix
# - 新功能: feat|feature → feature|enhancement
```

**步骤 4: 使用 GitHub API 创建 PR（保留 HTML 注释）**

```bash
# 创建 PR
“请使用以下信息创建 Draft PR：
- 标题: 从提交信息自动生成
- 描述: 使用 .github/PULL_REQUEST_TEMPLATE.md 适当填写
- 标签: 从变更内容中自动选择（最多 3 个）
- 基础分支: main
- 完全保留 HTML 注释”
```

**方法 B: GitHub MCP（备用）**

```javascript
// 创建保留 HTML 注释的 PR
mcp_github_create_pull_request({
  owner: 'organization',
  repo: 'repository',
  base: 'main',
  head: 'feat-user-authentication',
  title: 'feat: 实现用户认证',
  body: prBodyContent, // 包含 HTML 注释的完整内容
  draft: true,
  maintainer_can_modify: true,
});
```

### 自动标签选择系统

#### 基于文件模式的判断

- **文档**: `*.md`, `README`, `docs/` → `documentation|docs|doc`
- **测试**: `test`, `spec` → `test|testing`
- **CI/CD**: `.github/`, `*.yml`, `Dockerfile` → `ci|build|infra|ops`
- **依赖**: `package.json`, `pubspec.yaml` → `dependencies|deps`

#### 基于变更内容的判断

- **错误修复**: `fix|bug|error|crash|修复` → `bug|fix`
- **新功能**: `feat|feature|add|implement|新功能|实现` → `feature|enhancement|feat`
- **重构**: `refactor|clean|リファクタ` → `refactor|cleanup|clean`
- **性能**: `performance|perf|optimize` → `performance|perf`
- **安全**: `security|secure` → `security`

#### 限制

- **最多 3 个**: 自动选择的上限
- **仅限现有标签**: 禁止创建新标签
- **部分匹配**: 通过包含关键字进行判断

### 项目指南

#### 基本姿态

1. **始终以 Draft 开始**: 所有 PR 都以 Draft 状态创建
2. **分阶段提高质量**: 阶段 1（基本实现）→ 阶段 2（添加测试）→ 阶段 3（更新文档）
3. **适当的标签**: 始终附加最多 3 种标签
4. **使用模板**: 始终使用 `.github/PULL_REQUEST_TEMPLATE.md`
5. **中文空格**: 中文和半角英数字之间始终使用半角空格

#### 分支命名规则

```text
{type}-{subject}

示例:
- feat-user-profile
- fix-login-error
- refactor-api-client
```

#### 提交信息

```text
{type}: {description}

示例:
- feat: 实现用户认证 API
- fix: 修复登录错误
- docs: 更新 README
```

### 模板处理系统

#### 处理优先级

1. **现有 PR 描述**: **完全遵循**已有的内容
2. **项目模板**: 维持 `.github/PULL_REQUEST_TEMPLATE.md` 的结构
3. **默认模板**: 如果上述模板不存在

#### 现有内容保留规则

- **一字不改**: 已有的内容
- **仅补充空的部分**: 用变更内容填充占位符部分
- **保留功能性注释**: 维持 `<!-- Copilot review rule -->` 等
- **保留 HTML 注释**: 完全保留 `<!-- ... -->`
- **保留分隔线**: 维持 `---` 等结构

#### HTML 注释保留的处理方法

**重要**: GitHub CLI (`gh pr edit`) 会自动转义 HTML 注释，并且在 shell 处理中可能会混入 `EOF < /dev/null` 等无效字符串。

**根本解决方案**:

1. **使用 GitHub API 的 --field 选项**: 通过适当的转义处理保留 HTML 注释
2. **简化模板处理**: 避免复杂的管道处理或重定向
3. **完全保留方法**: 废除 HTML 注释删除处理，完全保留模板

### 审查评论处理

```bash
# 变更后重新提交
git add .
git commit -m "fix: 根据审查反馈进行修复"
git push
```

### 注意事项

#### HTML 注释保留的重要性

- **GitHub CLI 限制**: `gh pr edit` 会转义 HTML 注释，混入无效字符串
- **根本规避方法**: 使用 GitHub API 的 `--field` 选项进行适当的转义处理
- **完全保留模板**: 废除 HTML 注释删除处理，完全维持结构

#### 自动化的限制

- **禁止新标签**: 不可创建 `.github/labels.yml` 定义之外的标签
- **最多 3 个标签**: 自动选择的上限
- **现有内容优先**: 不会更改任何手动编写的内容

#### 分阶段提高质量

- **必须是 Draft**: 所有 PR 都以 Draft 开始
- **CI 确认**: 使用 `gh pr checks` 确认状态
- **转为 Ready**: 质量确认完成后使用 `gh pr ready`
- **完全遵守模板**: 维持项目特有的结构
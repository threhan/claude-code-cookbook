## 提交信息

从暂存的变更（git diff --staged）中生成适当的提交信息。不执行 git 命令，仅生成信息并复制到剪贴板。

### 使用方法

```bash
/commit-message [选项]
```

### 选项

- `--format <格式>` : 指定信息格式（conventional, gitmoji, angular）
- `--lang <语言>` : 强制指定信息语言（en, zh）
- `--breaking` : 检测并记录 Breaking Change

### 基本示例

```bash
# 从暂存的变更中生成信息（自动判断语言）
# 主要候选信息会自动复制到剪贴板
/commit-message

# 强制指定语言
/commit-message --lang zh
/commit-message --lang en

# 检测 Breaking Change
/commit-message --breaking
```

### 前提条件

**重要**: 此命令仅分析暂存的变更。需要事先使用 `git add` 暂存变更。

```bash
# 未暂存时会显示警告
$ /commit-message
没有暂存的变更。请先执行 git add。
```

### 自动剪贴板功能

生成的主要候选信息会以 `git commit -m "信息"` 的完整格式自动复制到剪贴板。可以直接在终端中粘贴并执行。

**实现时的注意事项**:

- 将提交命令传递给 `pbcopy` 时，应与信息输出在不同进程中执行
- 使用 `printf` 代替 `echo` 以避免末尾的换行符

### 自动检测项目规范

**重要**: 如果存在项目独有的规范，则优先使用。

#### 1. 确认 CommitLint 配置

从以下文件自动检测配置：

- `commitlint.config.js`
- `commitlint.config.mjs`
- `commitlint.config.cjs`
- `commitlint.config.ts`
- `.commitlintrc.js`
- `.commitlintrc.json`
- `.commitlintrc.yml`
- `.commitlintrc.yaml`
- `package.json` 的 `commitlint` 部分

```bash
# 搜索配置文件
find . -name "commitlint.config.*" -o -name ".commitlintrc.*" | head -1
```

#### 2. 检测自定义类型

项目独有的类型示例：

```javascript
// commitlint.config.mjs
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore',
        'wip',      // 进行中
        'hotfix',   // 紧急修复
        'release',  // 发布
        'deps',     // 依赖更新
        'config'    // 配置变更
      ]
    ]
  }
}
```

#### 3. 检测语言设置

```javascript
// 如果项目使用中文信息
export default {
  rules: {
    'subject-case': [0],  // 为支持中文而禁用
    'subject-max-length': [2, 'always', 72]  // 中文的字数限制调整
  }
}
```

#### 4. 分析现有提交历史

```bash
# 从最近的提交中学习使用模式
git log --oneline -50 --pretty=format:"%s"

# 统计使用类型
git log --oneline -100 --pretty=format:"%s" | \
grep -oE '^[a-z]+(\([^)]+\))?' | \
sort | uniq -c | sort -nr
```

### 自动判断语言

在以下条件下自动切换中文/英文：

1. **从 CommitLint 配置**确认语言设置
2. **通过 git log 分析**自动判断
3. **项目文件**的语言设置
4. **分析变更文件内**的注释/字符串

默认为英文。如果判断为中文项目，则生成中文。

### 信息格式

#### Conventional Commits (默认)

```
<type>: <description>
```

**重要**: 始终生成单行提交信息。不生成多行信息。

**注意**: 如果项目有独有的规范，则优先使用。

### 标准类型

**必需类型**:

- `feat`: 新功能（用户可见的功能添加）
- `fix`: Bug 修复

**可选类型**:

- `build`: 构建系统或外部依赖的变更
- `chore`: 其他变更（不影响发布）
- `ci`: CI 配置文件或脚本的变更
- `docs`: 仅文档变更
- `style`: 不影响代码含义的变更（空格、格式、分号等）
- `refactor`: 不涉及 Bug 修复或功能添加的代码重构
- `perf`: 性能改进
- `test`: 添加或修改测试

### 输出示例（英文项目）

```bash
$ /commit-message

📝 提交信息建议
━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要候选:
feat: implement JWT-based authentication system

📋 备选方案:
1. feat: add user authentication with JWT tokens
2. fix: resolve token validation error in auth middleware
3. refactor: extract auth logic into separate module

✅ 已将 `git commit -m "feat: implement JWT-based authentication system"` 复制到剪贴板
```

**实现示例（修复版）**:

```bash
# 先将提交命令复制到剪贴板（无换行）
printf 'git commit -m "%s"' "$COMMIT_MESSAGE" | pbcopy

# 然后显示信息
cat << EOF
📝 提交信息建议
━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要候选:
$COMMIT_MESSAGE

📋 备选方案:
1. ...
2. ...
3. ...

✅ 已将 \`git commit -m \"$COMMIT_MESSAGE\"\` 复制到剪贴板
EOF
```

### 输出示例（中文项目）

```bash
$ /commit-message

📝 提交信息建议
━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要候选:
feat: 实现 JWT 认证系统

📋 备选方案:
1. feat: 添加 JWT 令牌的用户认证
2. fix: 解决认证中间件的令牌验证错误
3. docs: 将认证逻辑分离到单独的模块

✅ 已将 `git commit -m "feat: 实现 JWT 认证系统"` 复制到剪贴板
```

### 工作概要

1. **分析**: 分析 `git diff --staged` 的内容
2. **生成**: 生成适当的提交信息
3. **复制**: 自动将主要候选信息复制到剪贴板

**注意**: 此命令不执行 git add 或 git commit。仅生成提交信息并复制到剪贴板。

### 智能功能

#### 1. 自动分类变更内容（仅限暂存的文件）

- 添加新文件 → `feat`
- 错误修复模式 → `fix`
- 仅测试文件 → `test`
- 配置文件变更 → `chore`
- README/docs 更新 → `docs`

#### 2. 自动检测项目规范

- `.gitmessage` 文件
- `CONTRIBUTING.md` 中的规范
- 过去的提交历史模式

#### 3. 语言判断详情（仅限暂存的变更）

```bash
# 判断标准（优先级）
1. 从 git diff --staged 的内容判断语言
2. 分析暂存文件的注释
3. 分析 git log --oneline -20 的语言
4. 项目的主要语言设置
```

#### 4. 暂存分析详情

用于分析的信息（只读）：

- `git diff --staged --name-only` - 变更文件列表
- `git diff --staged` - 实际变更内容
- `git status --porcelain` - 文件状态

### 检测到 Breaking Change 时

当存在 API 的破坏性变更时：

**英文**:

```bash
feat!: change user API response format

BREAKING CHANGE: user response now includes additional metadata
```

或者

```bash
feat(api)!: change authentication flow
```

**中文**:

```bash
feat!: 更改用户 API 响应格式

BREAKING CHANGE: 响应现在包含额外的元数据
```

或者

```bash
feat(api)!: 更改认证流程
```

### 最佳实践

1. **与项目保持一致**: 遵循现有的提交语言
2. **简洁**: 在 50 个字符内清晰表达
3. **一致性**: 不混合使用（如果使用英文，则统一使用英文）
4. **OSS**: 开源项目建议使用英文
5. **严格遵守单行**: 始终使用单行提交信息（如果需要详细说明，请在 PR 中补充）

### 常见模式

**英文**:

```
feat: add user registration endpoint
fix: resolve memory leak in cache manager
docs: update API documentation
```

**中文**:

```
feat: 添加用户注册端点
fix: 解决缓存管理器的内存泄漏
docs: 更新 API 文档
```

### 与 Claude 协作

```bash
# 与暂存的变更结合使用
git add -p  # 交互式暂存
/commit-message
“请生成最佳的提交信息”

# 仅暂存特定文件并分析
git add src/auth/*.js
/commit-message --lang en
“请为与认证相关的变更生成适当的信息”

# 检测并处理 Breaking Change
git add -A
/commit-message --breaking
“如果存在破坏性变更，请适当标记”
```

### 注意事项

- **前提条件**: 变更需要事先使用 `git add` 进行暂存
- **限制**: 未暂存的变更不属于分析对象
- **建议**: 请事先确认项目的现有提交规范
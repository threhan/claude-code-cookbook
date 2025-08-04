## 语义化提交

将大的变更分解为有意义的最小单元，并使用语义化的提交信息依次提交。不依赖外部工具，仅使用 git 标准命令。

### 使用方法

```bash
/semantic-commit [选项]
```

### 选项

- `--dry-run` : 不执行实际提交，仅显示建议的提交拆分
- `--lang <语言>` : 强制指定提交信息的语言（en, zh）
- `--max-commits <数量>` : 指定最大提交数（默认为 10）

### 基本示例

```bash
# 分析当前变更并按逻辑单元提交
/semantic-commit

# 仅确认拆分方案（不实际提交）
/semantic-commit --dry-run

# 生成英文提交信息
/semantic-commit --lang en

# 最多拆分为 5 个提交
/semantic-commit --max-commits 5
```

### 工作流程

1. **变更分析**: 使用 `git diff HEAD` 获取所有变更
2. **文件分类**: 将变更的文件按逻辑分组
3. **提交建议**: 为每个组生成语义化的提交信息
4. **依次执行**: 用户确认后，依次提交每个组

### 变更拆分的核心功能

#### “大变更”的检测

在以下条件下检测为大变更：

1. **变更文件数**: 变更文件超过 5 个
2. **变更行数**: 变更行数超过 100 行
3. **多功能**: 变更涉及 2 个以上的功能领域
4. **混合模式**: feat + fix + docs 混合存在

```bash
# 变更规模分析
CHANGED_FILES=$(git diff HEAD --name-only | wc -l)
CHANGED_LINES=$(git diff HEAD --stat | tail -1 | grep -o '[0-9]\+ insertions\|[0-9]\+ deletions' | awk '{sum+=$1} END {print sum}')

if [ $CHANGED_FILES -ge 5 ] || [ $CHANGED_LINES -ge 100 ]; then
  echo "检测到大变更：建议拆分"
fi
```

#### “有意义的最小单元”拆分策略

##### 1. 按功能边界拆分

```bash
# 从目录结构中识别功能单元
git diff HEAD --name-only | cut -d'/' -f1-2 | sort | uniq
# → src/auth, src/api, components/ui 等
```

##### 2. 按变更类型分离

```bash
# 新文件 vs 现有文件修改
git diff HEAD --name-status | grep '^A' # 新文件
git diff HEAD --name-status | grep '^M' # 修改的文件
git diff HEAD --name-status | grep '^D' # 删除的文件
```

##### 3. 依赖关系分析

```bash
# 检测导入关系的变更
git diff HEAD | grep -E '^[+-].*import|^[+-].*require' | \
cut -d' ' -f2- | sort | uniq
```

#### 文件级详细分析

```bash
# 获取变更的文件列表
git diff HEAD --name-only

# 单独分析每个文件的变更内容
git diff HEAD -- <file>

# 判断文件的变更类型
git diff HEAD --name-status | while read status file; do
  case $status in
    A) echo "$file: 新建" ;; 
    M) echo "$file: 修改" ;; 
    D) echo "$file: 删除" ;; 
    R*) echo "$file: 重命名" ;; 
  esac
done
```

#### 逻辑分组标准

1. **功能单元**: 与同一功能相关的文件
   - `src/auth/` 下的文件 → 认证功能
   - `components/` 下的文件 → UI 组件

2. **变更类型**: 相同类型的变更
   - 仅测试文件 → `test:`
   - 仅文档 → `docs:`
   - 仅配置文件 → `chore:`

3. **依赖关系**: 相互关联的文件
   - 模型 + 迁移
   - 组件 + 样式

4. **变更规模**: 保持适当的提交大小
   - 每个提交不超过 10 个文件
   - 将高度相关的文件分组

### 输出示例

```bash
$ /semantic-commit

正在分析变更...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

检测到的变更:
• src/auth/login.ts (修改)
• src/auth/register.ts (新建)
• src/auth/types.ts (修改)
• tests/auth.test.ts (新建)
• docs/authentication.md (新建)

建议的提交拆分:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
提交 1/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
信息: feat: implement user registration and login system
包含的文件:
  • src/auth/login.ts
  • src/auth/register.ts  
  • src/auth/types.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
提交 2/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
信息: test: add comprehensive tests for authentication system
包含的文件:
  • tests/auth.test.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
提交 3/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
信息: docs: add authentication system documentation
包含的文件:
  • docs/authentication.md

是否按此拆分方案执行提交？ (y/n/edit): 
```

### 执行时的选项

- `y` : 按建议的提交拆分执行
- `n` : 取消
- `edit` : 单独编辑提交信息
- `merge <编号 1> <编号 2>` : 合并指定的提交
- `split <编号>` : 进一步拆分指定的提交

### Dry Run 模式

```bash
$ /semantic-commit --dry-run

正在分析变更... (DRY RUN)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[显示提交拆分建议]

ℹ️  DRY RUN 模式：不执行实际提交
💡 如需执行，请去掉 --dry-run 选项后重新运行
```

### 智能分析功能

#### 1. 理解项目结构

- 从 `package.json`, `Cargo.toml`, `pom.xml` 等判断项目类型
- 从文件夹结构推断功能单元

#### 2. 识别变更模式

```bash
# 检测 Bug 修复模式
- “fix”, “bug”, “error” 等关键字
- 添加异常处理
- 修改条件分支

# 检测新功能模式
- 创建新文件
- 添加新方法
- 添加 API 端点
```

#### 3. 分析依赖关系

- 导入语句的变更
- 类型定义的添加/修改
- 与配置文件的关联性

### 技术实现

#### 使用 Git 标准命令实现顺序提交

##### 1. 预处理：保存当前状态

```bash
# 如果有未暂存的变更，则暂时重置
git reset HEAD
git status --porcelain > /tmp/original_state.txt

# 确认工作分支
CURRENT_BRANCH=$(git branch --show-current)
echo "当前工作分支: $CURRENT_BRANCH"
```

##### 2. 按组顺序执行提交

```bash
# 读取拆分计划
while IFS= read -r commit_plan; do
  group_num=$(echo "$commit_plan" | cut -d':' -f1)
  files=$(echo "$commit_plan" | cut -d':' -f2- | tr ' ' '\n')
  
  echo "=== 正在执行提交 $group_num ==="
  
  # 仅暂存相关文件
  echo "$files" | while read file; do
    if [ -f "$file" ]; then
      git add "$file"
      echo "正在暂存: $file"
    fi
  done
  
  # 确认暂存状态
  staged_files=$(git diff --staged --name-only)
  if [ -z "$staged_files" ]; then
    echo "警告：没有暂存的文件"
    continue
  fi
  
  # 生成提交信息（通过 LLM 分析）
  commit_msg=$(generate_commit_message_for_staged_files)
  
  # 用户确认
  echo "建议的提交信息: $commit_msg"
  echo "暂存的文件:"
  echo "$staged_files"
  read -p "是否执行此提交？ (y/n): " confirm
  
  if [ "$confirm" = "y" ]; then
    # 执行提交
    git commit -m "$commit_msg"
    echo "✅ 提交 $group_num 完成"
  else
    # 取消暂存
    git reset HEAD
    echo "❌ 已跳过提交 $group_num"
  fi
  
done < /tmp/commit_plan.txt
```

##### 3. 错误处理和回滚

```bash
# 预提交钩子失败时的处理
commit_with_retry() {
  local commit_msg="$1"
  local max_retries=2
  local retry_count=0
  
  while [ $retry_count -lt $max_retries ]; do
    if git commit -m "$commit_msg"; then
      echo "✅ 提交成功"
      return 0
    else
      echo "❌ 提交失败 (尝试 $((retry_count + 1))/$max_retries)"
      
      # 包含预提交钩子自动修复的变更
      if git diff --staged --quiet; then
        echo "预提交钩子已自动修复变更"
        git add -u
      fi
      
      retry_count=$((retry_count + 1))
    fi
  done
  
  echo "❌ 提交失败。请手动确认。"
  return 1
}

# 从中断中恢复
resume_from_failure() {
  echo "检测到中断的提交处理"
  echo "当前暂存状态:"
  git status --porcelain
  
  read -p "是否继续处理？ (y/n): " resume
  if [ "$resume" = "y" ]; then
    # 从最后一个提交位置恢复
    last_commit=$(git log --oneline -1 --pretty=format:"%s")
    echo "最后一个提交: $last_commit"
  else
    # 完全重置
    git reset HEAD
    echo "已重置处理"
  fi
}
```

##### 4. 完成后验证

```bash
# 确认所有变更是否已提交
remaining_changes=$(git status --porcelain | wc -l)
if [ $remaining_changes -eq 0 ]; then
  echo "✅ 所有变更已提交"
else
  echo "⚠️  仍有未提交的变更:"
  git status --short
fi

# 显示提交历史
echo "创建的提交:"
git log --oneline -n 10 --graph
```

##### 5. 抑制自动推送

```bash
# 注意：不执行自动推送
echo "📝 注意：不执行自动推送"
echo "如有需要，请使用以下命令推送:"
echo "  git push origin $CURRENT_BRANCH"
```

#### 拆分算法详情

##### 步骤 1：初步分析

```bash
# 获取并分类所有变更文件
git diff HEAD --name-status | while read status file; do
  echo "$status:$file"
done > /tmp/changes.txt

# 按功能目录统计变更
git diff HEAD --name-only | cut -d'/' -f1-2 | sort | uniq -c
```

##### 步骤 2：按功能边界进行初步分组

```bash
# 基于目录的分组
GROUPS=$(git diff HEAD --name-only | cut -d'/' -f1-2 | sort | uniq)
for group in $GROUPS; do
  echo "=== 组: $group ==="
  git diff HEAD --name-only | grep "^$group" | head -10
done
```

##### 步骤 3：分析变更内容的相似性

```bash
# 分析每个文件的变更类型
git diff HEAD --name-only | while read file; do
  # 检测新函数/类的添加
  NEW_FUNCTIONS=$(git diff HEAD -- "$file" | grep -c '^+.*function\|^+.*class\|^+.*def ')
  
  # 检测 Bug 修复模式
  BUG_FIXES=$(git diff HEAD -- "$file" | grep -c '^+.*fix\|^+.*bug\|^-.*error')
  
  # 判断是否为测试文件
  if [[ "$file" =~ test|spec ]]; then
    echo "$file: TEST"
  elif [ $NEW_FUNCTIONS -gt 0 ]; then
    echo "$file: FEAT"
  elif [ $BUG_FIXES -gt 0 ]; then
    echo "$file: FIX"
  else
    echo "$file: REFACTOR"
  fi
done
```

##### 步骤 4：根据依赖关系进行调整

```bash
# 分析导入关系
git diff HEAD | grep -E '^[+-].*import|^[+-].*from.*import' | \
while read line; do
  echo "$line" | sed 's/^[+-]//' | awk '{print $2}'
done | sort | uniq > /tmp/imports.txt

# 分组相关文件
git diff HEAD --name-only | while read file; do
  basename=$(basename "$file" .js .ts .py)
  related=$(git diff HEAD --name-only | grep "$basename" | grep -v "^$file$")
  if [ -n "$related" ]; then
    echo "相关文件组: $file <-> $related"
  fi
done
```

##### 步骤 5：优化提交大小

```bash
# 调整组大小
MAX_FILES_PER_COMMIT=8
current_group=1
file_count=0

git diff HEAD --name-only | while read file; do
  if [ $file_count -ge $MAX_FILES_PER_COMMIT ]; then
    current_group=$((current_group + 1))
    file_count=0
  fi
  echo "提交 $current_group: $file"
  file_count=$((file_count + 1))
done
```

##### 步骤 6：确定最终分组

```bash
# 验证拆分结果
for group in $(seq 1 $current_group); do
  files=$(grep "提交 $group:" /tmp/commit_plan.txt | cut -d':' -f2-)
  lines=$(echo "$files" | xargs git diff HEAD -- | wc -l)
  echo "提交 $group: $(echo "$files" | wc -w) 个文件, $lines 行变更"
done
```

### 遵循 Conventional Commits

#### 基本格式

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### 标准类型

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

#### 范围（可选）

表示变更的影响范围：

```
feat(api): add user authentication endpoint
fix(ui): resolve button alignment issue
docs(readme): update installation instructions
```

#### Breaking Change

当存在 API 的破坏性变更时：

```
feat!: change user API response format

BREAKING CHANGE: user response now includes additional metadata
```

或者

```
feat(api)!: change authentication flow
```

#### 自动检测项目规范

**重要**: 如果存在项目独有的规范，则优先使用。

##### 1. 确认 CommitLint 配置

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
# 确认配置文件示例
cat commitlint.config.mjs
cat .commitlintrc.json
grep -A 10 '"commitlint"' package.json
```

##### 2. 检测自定义类型

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

##### 3. 检测语言设置

```javascript
// 如果项目使用中文信息
export default {
  rules: {
    'subject-case': [0],  // 为支持中文而禁用
    'subject-max-length': [2, 'always', 72]  // 中文的字数限制调整
  }
}
```

#### 自动分析流程

1. **搜索配置文件**

   ```bash
   find . -name "commitlint.config.*" -o -name ".commitlintrc.*" | head -1
   ```

2. **分析现有提交**

   ```bash
   git log --oneline -50 --pretty=format:"%s"
   ```

3. **统计使用类型**

   ```bash
   git log --oneline -100 --pretty=format:"%s" | \
   grep -oE '^[a-z]+(\([^)]+\))?' | \
   sort | uniq -c | sort -nr
   ```

#### 项目规范示例

##### Angular 风格

```
feat(scope): add new feature
fix(scope): fix bug
docs(scope): update documentation
```

##### 与 Gitmoji 结合的风格

```
✨ feat: add user registration
🐛 fix: resolve login issue
📚 docs: update API docs
```

##### 中文项目

```
feat: 添加用户注册功能
fix: 修复登录处理的 Bug
docs: 更新 API 文档
```

### 语言判断

此命令内完成的语言判断逻辑：

1. **从 CommitLint 配置**确认语言设置

   ```bash
   # 如果 subject-case 规则被禁用，则判断为中文
   grep -E '"subject-case".*\[0\]|subject-case.*0' commitlint.config.*
   ```

2. **通过 git log 分析**自动判断

   ```bash
   # 分析最近 20 个提交的语言
   git log --oneline -20 --pretty=format:"%s" | \
   grep -cE '[\u4e00-\u9fa5]' 2>/dev/null || echo 0
   # 如果 50% 以上是中文，则为中文模式
   ```

3. **项目文件**的语言设置

   ```bash
   # 确认 README.md 的语言
   head -10 README.md | grep -E '[\u4e00-\u9fa5]' | wc -l
   
   # 确认 package.json 的 description
   grep -E '"description".*[一-龥]' package.json
   ```

4. **分析变更文件内**的注释/字符串

   ```bash
   # 确认变更文件的注释语言
   git diff HEAD | grep -E '^[+-].*//.*[一-龥]' | wc -l
   ```

#### 判断算法

```bash
# 语言判断分数计算
CHINESE_SCORE=0

# 1. CommitLint 配置 (+3 分)
if grep -q '"subject-case".*\[0\]' commitlint.config.* 2>/dev/null; then
  CHINESE_SCORE=$((CHINESE_SCORE + 3))
fi

# 2. git log 分析 (最多+2 分)
CHINESE_COMMITS=$(git log --oneline -20 --pretty=format:"%s" | \
  grep -cE '[\u4e00-\u9fa5]' 2>/dev/null || echo 0)
if [ $CHINESE_COMMITS -gt 10 ]; then
  CHINESE_SCORE=$((CHINESE_SCORE + 2))
elif [ $CHINESE_COMMITS -gt 5 ]; then
  CHINESE_SCORE=$((CHINESE_SCORE + 1))
fi

# 3. 确认 README.md (+1 分)
if head -5 README.md 2>/dev/null | grep -qE '[\u4e00-\u9fa5]'; then
  CHINESE_SCORE=$((CHINESE_SCORE + 1))
fi

# 4. 确认变更文件内容 (+1 分)
if git diff HEAD 2>/dev/null | grep -qE '^[+-].*[一-龥]'; then
  CHINESE_SCORE=$((CHINESE_SCORE + 1))
fi

# 判断：3 分以上为中文模式
if [ $CHINESE_SCORE -ge 3 ]; then
  LANGUAGE="zh"
else
  LANGUAGE="en"
fi
```

### 自动读取配置文件

#### 执行时的行为

命令执行时按以下顺序确认配置：

1. **搜索 CommitLint 配置文件**

   ```bash
   # 按以下顺序搜索，并使用第一个找到的文件
   commitlint.config.mjs
   commitlint.config.js  
   commitlint.config.cjs
   commitlint.config.ts
   .commitlintrc.js
   .commitlintrc.json
   .commitlintrc.yml
   .commitlintrc.yaml
   package.json (commitlint 部分)
   ```

2. **解析配置内容**
   - 提取可用的类型列表
   - 确认是否有范围限制
   - 获取信息长度限制
   - 确认语言设置

3. **分析现有提交历史**

   ```bash
   # 从最近的提交中学习使用模式
   git log --oneline -100 --pretty=format:"%s" | \
   head -20
   ```

#### 配置示例分析

**标准的 commitlint.config.mjs**:

```javascript
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore']
    ],
    'scope-enum': [
      2,
      'always',
      ['api', 'ui', 'core', 'auth', 'db']
    ]
  }
}
```

**支持中文的配置**:

```javascript
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'subject-case': [0],  // 为支持中文而禁用
    'subject-max-length': [2, 'always', 72],
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore']
    ]
  }
}
```

**包含自定义类型的配置**:

```javascript
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore',
        'wip',      // Work in Progress
        'hotfix',   // 紧急修复
        'release',  // 准备发布
        'deps',     // 依赖更新
        'config'    // 配置变更
      ]
    ]
  }
}
```

#### 回退行为

如果找不到配置文件：

1. **通过 git log 分析**自动推断

   ```bash
   # 从最近 100 个提交中提取类型
   git log --oneline -100 --pretty=format:"%s" | \
   grep -oE '^[a-z]+(\([^)]+\))?' | \
   sort | uniq -c | sort -nr
   ```

2. **默认使用 Conventional Commits 标准**

   ```
   feat, fix, docs, style, refactor, perf, test, chore, build, ci
   ```

3. **语言判断**
   - 中文提交占 50% 以上 → 中文模式
   - 其他 → 英文模式

### 前提条件

- 在 Git 仓库内执行
- 存在未提交的变更
- 已暂存的变更将被暂时重置

### 注意事项

- **无自动推送**: 提交后的 `git push` 需手动执行
- **无分支创建**: 在当前分支上提交
- **建议备份**: 在进行重要变更前使用 `git stash` 备份

### 项目规范的优先级

生成提交信息时的优先级：

1. **CommitLint 配置** (最高优先级)
   - `commitlint.config.*` 文件的配置
   - 自定义类型或范围的限制
   - 信息长度或大小写的限制

2. **现有提交历史** (第二优先级)
   - 实际使用的类型统计
   - 信息的语言（中文/英文）
   - 范围的使用模式

3. **项目类型** (第三优先级)
   - `package.json` → Node.js 项目
   - `Cargo.toml` → Rust 项目  
   - `pom.xml` → Java 项目

4. **Conventional Commits 标准** (回退)
   - 找不到配置时的标准行为

#### 规范检测实例

**在 Monorepo 中自动检测 scope**:

```bash
# 从 packages/ 文件夹推断 scope
l s packages/ | head -10
# → 建议将 api, ui, core, auth 等作为 scope
```

**框架特有的规范**:

```javascript
// Angular 项目的情况
{
  'scope-enum': [2, 'always', [
    'animations', 'common', 'core', 'forms', 'http', 'platform-browser',
    'platform-server', 'router', 'service-worker', 'upgrade'
  ]]
}

// React 项目的情况
{
  'scope-enum': [2, 'always', [
    'components', 'hooks', 'utils', 'types', 'styles', 'api'
  ]]
}
```

**企业/团队特有的规范**:

```javascript
// 在中国公司常见的模式
{
  'type-enum': [2, 'always', [
    'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore',
    'wip',      // 进行中（用于拉取请求）
    'hotfix',   // 紧急修复
    'release'   // 准备发布
  ]],
  'subject-case': [0],  // 支持中文
  'subject-max-length': [2, 'always', 72]  // 中文设置得更长
}
```

### 最佳实践

1. **尊重项目规范**: 遵循现有的配置和模式
2. **小的变更单元**: 一个提交对应一个逻辑变更
3. **明确的信息**: 清楚地说明变更了什么
4. **重视关联性**: 将功能上相关的文件分组
5. **分离测试**: 将测试文件放在单独的提交中
6. **利用配置文件**: 引入 CommitLint，在整个团队中统一规范

### 实际拆分示例（Before/After）

#### 示例 1：大规模认证系统添加

**Before（一个巨大的提交）:**

```bash
# 变更的文件（15 个文件，850 行变更）
src/auth/login.js          # 新建
src/auth/register.js       # 新建
src/auth/password.js       # 新建
src/auth/types.js          # 新建
src/api/auth-routes.js     # 新建
src/middleware/auth.js     # 新建
src/database/migrations/001_users.sql  # 新建
src/database/models/user.js            # 新建
tests/auth/login.test.js   # 新建
tests/auth/register.test.js # 新建
tests/api/auth-routes.test.js # 新建
docs/authentication.md    # 新建
package.json              # 添加依赖
README.md                 # 添加使用方法
.env.example             # 添加环境变量示例

# 有问题的传统提交
feat: implement complete user authentication system with login, registration, password reset, API routes, database models, tests and documentation
```

**After（按类型拆分为 5 个提交）:**

```bash
# 提交 1：数据库基础
feat(db): add user model and authentication schema

包含的文件:
- src/database/migrations/001_users.sql
- src/database/models/user.js
- src/auth/types.js

原因: 数据库结构是其他功能的基础，因此最先提交

# 提交 2：认证逻辑
feat(auth): implement core authentication functionality  

包含的文件:
- src/auth/login.js
- src/auth/register.js
- src/auth/password.js
- src/middleware/auth.js

原因: 将认证的核心业务逻辑一次性提交

# 提交 3：API 端点
feat(api): add authentication API routes

包含的文件:
- src/api/auth-routes.js

原因: API 层依赖于认证逻辑，因此稍后提交

# 提交 4：全面的测试
test(auth): add comprehensive authentication tests

包含的文件:
- tests/auth/login.test.js
- tests/auth/register.test.js  
- tests/api/auth-routes.test.js

原因: 实现完成后一次性添加测试

# 提交 5：配置和文档
docs(auth): add authentication documentation and configuration

包含的文件:
- docs/authentication.md
- package.json
- README.md
- .env.example

原因: 最后统一提交文档和配置
```

#### 示例 2：Bug 修复和重构混合

**Before（混合了问题的提交）:**

```bash
# 变更的文件（8 个文件，320 行变更）
src/user/service.js       # Bug 修复 + 重构
src/user/validator.js     # 新建（重构）
src/auth/middleware.js    # Bug 修复
src/api/user-routes.js    # Bug 修复 + 错误处理改进
tests/user.test.js        # 添加测试
tests/auth.test.js        # 添加 Bug 修复测试
docs/user-api.md          # 更新文档
package.json              # 更新依赖

# 有问题的提交
fix: resolve user validation bugs and refactor validation logic with improved error handling
```

**After（按类型拆分为 3 个提交）:**

```bash
# 提交 1：紧急 Bug 修复
fix: resolve user validation and authentication bugs

包含的文件:
- src/user/service.js（仅 Bug 修复部分）
- src/auth/middleware.js
- tests/auth.test.js（仅 Bug 修复测试）

原因: 影响生产环境的 Bug 最优先修复

# 提交 2：验证逻辑重构
refactor: extract and improve user validation logic

包含的文件:
- src/user/service.js（重构部分）
- src/user/validator.js
- src/api/user-routes.js
- tests/user.test.js

原因: 按功能单元统一提交结构改进

# 提交 3：文档和依赖更新
chore: update documentation and dependencies

包含的文件:
- docs/user-api.md
- package.json

原因: 最后统一提交开发环境的整理
```

#### 示例 3：多功能同时开发

**Before（跨功能的巨大提交）:**

```bash
# 变更的文件（12 个文件，600 行变更）
src/user/profile.js       # 新功能 A
src/user/avatar.js        # 新功能 A  
src/notification/email.js # 新功能 B
src/notification/sms.js   # 新功能 B
src/api/profile-routes.js # 新功能 A 的 API
src/api/notification-routes.js # 新功能 B 的 API
src/dashboard/widgets.js  # 新功能 C
src/dashboard/charts.js   # 新功能 C
tests/profile.test.js     # 新功能 A 的测试
tests/notification.test.js # 新功能 B 的测试
tests/dashboard.test.js   # 新功能 C 的测试
package.json              # 所有功能的依赖

# 有问题的提交
feat: add user profile management, notification system and dashboard widgets
```

**After（按功能拆分为 4 个提交）:**

```bash
# 提交 1：用户个人资料功能
feat(profile): add user profile management

包含的文件:
- src/user/profile.js
- src/user/avatar.js
- src/api/profile-routes.js
- tests/profile.test.js

原因: 个人资料功能是独立的功能单元

# 提交 2：通知系统
feat(notification): implement email and SMS notifications

包含的文件:
- src/notification/email.js
- src/notification/sms.js  
- src/api/notification-routes.js
- tests/notification.test.js

原因: 通知功能是独立的功能单元

# 提交 3：仪表板小部件
feat(dashboard): add interactive widgets and charts

包含的文件:
- src/dashboard/widgets.js
- src/dashboard/charts.js
- tests/dashboard.test.js

原因: 仪表板功能是独立的功能单元

# 提交 4：依赖和基础设施更新
chore: update dependencies for new features

包含的文件:
- package.json

原因: 最后统一更新公共依赖
```

### 拆分效果比较

| 项目 | Before（巨大提交） | After（适当拆分） |
|---|---|---|
| **可审查性** | ❌ 非常困难 | ✅ 每个提交都很小，易于审查 |
| **Bug 追踪** | ❌ 难以定位问题 | ✅ 可立即定位有问题的提交 |
| **回滚** | ❌ 需要回滚整个变更 | ✅ 可精确回滚问题部分 |
| **并行开发** | ❌ 容易发生冲突 | ✅ 按功能易于合并 |
| **部署** | ❌ 一次性部署所有功能 | ✅ 可分阶段部署 |

### 故障排除

#### 提交失败时

- 确认预提交钩子
- 解决依赖关系
- 在单个文件上重试

#### 拆分不合适时

- 使用 `--max-commits` 选项调整
- 手动使用 `edit` 模式
- 以更小的单元重新执行
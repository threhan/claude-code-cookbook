## 智能审查

分析当前情况，自动推荐最佳角色和方法的命令。

### 使用方法

```bash
/smart-review                    # 分析当前目录
/smart-review <文件/目录> # 分析特定对象
```

### 自动判断逻辑

### 根据文件扩展名判断

- `package.json`, `*.tsx`, `*.jsx`, `*.css`, `*.scss` → **frontend**
- `Dockerfile`, `docker-compose.yml`, `*.yaml` → **architect**
- `*.test.js`, `*.spec.ts`, `test/`, `__tests__/` → **qa**
- `*.rs`, `Cargo.toml`, `performance/` → **performance**

### 安全相关文件检测

- `auth.js`, `security.yml`, `.env`, `config/auth/` → **security**
- `login.tsx`, `signup.js`, `jwt.js` → **security + frontend**
- `api/auth/`, `middleware/auth/` → **security + architect**

### 复合判断模式

- `mobile/` + `*.swift`, `*.kt`, `react-native/` → **mobile**
- `webpack.config.js`, `vite.config.js`, `large-dataset/` → **performance**
- `components/` + `responsive.css` → **frontend + mobile**
- `api/` + `auth/` → **security + architect**

### 错误/问题分析

- 堆栈跟踪, `error.log`, `crash.log` → **analyzer**
- `memory leak`, `high CPU`, `slow query` → **performance + analyzer**
- `SQL injection`, `XSS`, `CSRF` → **security + analyzer**

### 提案模式

### 单一角色提案

```bash
$ /smart-review src/auth/login.js
→ “检测到认证文件”
→ “推荐使用 security 角色进行分析”
→ “是否执行？ [y]es / [n]o / [m]ore options”
```

### 多角色提案

```bash
$ /smart-review src/mobile/components/
→ “📱🎨 检测到移动 + 前端元素”
→ “推荐方法:”
→ “[1] 单独使用 mobile 角色”
→ “[2] 单独使用 frontend 角色”
→ “[3] multi-role mobile,frontend”
→ “[4] role-debate mobile,frontend”
```

### 问题分析时的提案

```bash
$ /smart-review error.log
→ “⚠️ 检测到错误日志”
→ “将使用 analyzer 角色开始根本原因分析”
→ “[自动执行] /role analyzer”

$ /smart-review slow-api.log
→ “🐌 检测到性能问题”
→ “推荐: [1]/role performance [2]/role-debate performance,analyzer”
```

### 复杂设计决策时的提案

```bash
$ /smart-review architecture-design.md
→ “🏗️🔒⚡ 检测到架构 + 安全 + 性能元素”
→ “由于是复杂的设计决策，推荐使用讨论形式”
→ “[推荐] /role-debate architect,security,performance”
→ “[替代方案] /multi-role architect,security,performance”
```

### 提案逻辑详情

### 优先级判断

1.  **Security** - 认证、授权、加密相关最优先
2.  **Critical Errors** - 系统停止、数据丢失是紧急情况
3.  **Architecture** - 大规模变更、技术选型需慎重考虑
4.  **Performance** - 直接影响用户体验
5.  **Frontend/Mobile** - UI/UX 改进
6.  **QA** - 质量保证、测试相关

### 推荐讨论的条件

- 涉及 3 个以上角色时
- 存在安全 vs 性能的权衡时
- 包含大规模架构变更时
- 同时影响移动端和 Web 端时

### 基本示例

```bash
# 分析当前目录
/smart-review
“请推荐最佳的角色和方法”

# 分析特定文件
/smart-review src/auth/login.js
“请为这个文件推荐最佳的审查方法”

# 分析错误日志
/smart-review error.log
“请为解决这个错误推荐最佳的方法”
```

### 实际案例

### 项目整体分析

```bash
$ /smart-review
→ “📊 正在分析项目...”
→ “检测到 React + TypeScript 项目”
→ “确认了认证功能 + API + 移动端适配”
→ “”
→ “💡 推荐工作流:”
→ “1. 使用 security 检查认证相关”
→ “2. 使用 frontend 评估 UI/UX”
→ “3. 使用 mobile 确认移动端优化”
→ “4. 使用 architect 审查整体设计”
→ “”
→ “是否自动执行？ [y]es / [s]elect role / [c]ustom”
```

### 特定问题分析

```bash
$ /smart-review "JWT 的有效期应该如何设置"
→ “🤔 检测到技术设计决策”
→ “这是一个需要多个专业视角的问题”
→ “”
→ “推荐方法:”
→ “/role-debate security,performance,frontend”
→ “原因: 安全、性能和 UX 之间的平衡很重要”
```

### 与 Claude 协作

```bash
# 结合文件内容进行分析
cat src/auth/middleware.js
/smart-review
“请结合此文件内容从安全角度进行分析”

# 结合错误进行分析
npm run build 2>&1 | tee build-error.log
/smart-review build-error.log
“请推荐解决构建错误的方法”

# 设计咨询
/smart-review
“请讨论应该选择 React Native 还是 Progressive Web App”
```

### 注意事项

- 提案仅供参考。最终决策由用户做出
- 问题越复杂，越推荐使用讨论形式（role-debate）
- 简单问题通常使用 single role 就足够了
- 安全相关问题强烈建议使用专业角色进行确认
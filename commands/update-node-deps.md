## Node Dependencies Update

安全地更新 Node.js 项目的依赖项。

### 使用方法

```bash
# 检查过时的依赖项并请求 Claude
npm outdated
"请将 package.json 中的依赖项更新到最新版本"
```

### 基本示例

```bash
# 检查当前依赖项
cat package.json
"请分析此 Node.js 项目的依赖项，并告诉我哪些包可以更新"

# 检查可更新列表
npm outdated
"请分析更新这些包的风险"
```

### 与 Claude 协作

```bash
# 全面的依赖项更新
cat package.json
"请分析 Node.js 依赖项并执行以下操作：
1. 调查每个包的最新版本
2. 检查是否存在重大更改
3. 评估风险（安全、注意、危险）
4. 提出必要的代码更改建议
5. 生成更新后的 package.json"

# 安全的逐步更新
npm outdated
"请仅更新可以安全升级的包，避免主版本升级"

# 特定包的更新影响分析
"请告诉我将 express 更新到最新版本的影响和必要的更改"
```

### 详细示例

```bash
# 包括发行说明的详细分析
cat package.json && npm outdated
"请分析依赖项，并以表格形式提供每个包的以下信息：
1. 当前版本 → 最新版本
2. 风险评估（安全、注意、危险）
3. 主要更改（来自 CHANGELOG）
4. 必要的代码修复"

# 考虑 TypeScript 项目的类型定义
cat package.json tsconfig.json
"请更新依赖项（包括 TypeScript 类型定义），并制定更新计划以避免类型错误"
```

### 风险标准

```
安全 (🟢):
- 补丁版本升级 (1.2.3 → 1.2.4)
- 仅修复错误
- 保证向后兼容

注意 (🟡):
- 次要版本升级 (1.2.3 → 1.3.0)
- 添加新功能
- 存在弃用警告

危险 (🔴):
- 主要版本升级 (1.2.3 → 2.0.0)
- 重大更改
- API 的删除或更改
```

### 执行更新

```bash
# 创建备份
cp package.json package.json.backup
cp package-lock.json package-lock.json.backup

# 执行更新
npm update

# 更新后检查
npm test
npm run build
npm audit
```

### 注意事项

更新后请务必检查操作。如果出现问题，请使用以下命令恢复：

```bash
cp package.json.backup package.json
cp package-lock.json.backup package-lock.json
npm install
```
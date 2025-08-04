## Rust Dependencies Update

安全地更新 Rust 项目的依赖项。

### 使用方法

```bash
# 检查依赖关系树并请求 Claude
cargo tree
"请将 Cargo.toml 中的依赖项更新到最新版本"
```

### 基本示例

```bash
# 检查当前依赖项
cat Cargo.toml
"请分析此 Rust 项目的依赖项，并告诉我哪些 crate 可以更新"

# 检查可更新列表
cargo update --dry-run
"请分析更新这些 crate 的风险"
```

### 与 Claude 协作

```bash
# 全面的依赖项更新
cat Cargo.toml
"请分析 Rust 依赖项并执行以下操作：
1. 调查每个 crate 的最新版本
2. 检查是否存在重大更改
3. 评估风险（安全、注意、危险）
4. 提出必要的代码更改建议
5. 生成更新后的 Cargo.toml"

# 安全的逐步更新
cargo tree
"请仅更新可以安全升级的 crate，避免主版本升级"

# 特定 crate 的更新影响分析
"请告诉我将 tokio 更新到最新版本的影响和必要的更改"
```

### 详细示例

```bash
# 包括发行说明的详细分析
cat Cargo.toml && cargo tree
"请分析依赖项，并以表格形式提供每个 crate 的以下信息：
1. 当前版本 → 最新版本
2. 风险评估（安全、注意、危险）
3. 主要更改（来自 CHANGELOG）
4. Trait 边界的更改
5. 必要的代码修复"

# 异步运行时迁移分析
cat Cargo.toml src/main.rs
"请提供从 async-std 迁移到 tokio，或 tokio 主版本升级所需的所有更改"
```

### 风险标准

```
安全 (🟢):
- 补丁版本升级 (0.1.2 → 0.1.3)
- 仅修复错误
- 保证向后兼容

注意 (🟡):
- 次要版本升级 (0.1.0 → 0.2.0)
- 添加新功能
- 存在弃用警告

危险 (🔴):
- 主要版本升级 (0.x.y → 1.0.0, 1.x.y → 2.0.0)
- 重大更改
- API 的删除或更改
- Trait 边界的更改
```

### 执行更新

```bash
# 创建备份
cp Cargo.toml Cargo.toml.backup
cp Cargo.lock Cargo.lock.backup

# 执行更新
cargo update

# 更新后检查
cargo check
cargo test
cargo clippy
```

### 注意事项

更新后请务必检查操作。如果出现问题，请使用以下命令恢复：

```bash
cp Cargo.toml.backup Cargo.toml
cp Cargo.lock.backup Cargo.lock
cargo build
```
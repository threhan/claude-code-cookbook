## 依赖分析

分析项目的依赖关系，并评估架构的健康状况。

### 使用方法

```bash
/dependency-analysis [选项]
```

### 选项

- `--visual` : 可视化显示依赖关系
- `--circular` : 仅检测循环依赖
- `--depth <数值>` : 指定分析深度（默认为 3）
- `--focus <路径>` : 聚焦于特定的模块/目录

### 基本示例

```bash
# 分析整个项目的依赖关系
/dependency-analysis

# 检测循环依赖
/dependency-analysis --circular

# 详细分析特定模块
/dependency-analysis --focus src/core --depth 5
```

### 分析项目

#### 1. 依赖关系矩阵

将模块间的依赖关系数字化并显示：

- 直接依赖
- 间接依赖
- 依赖深度
- 扇入/扇出

#### 2. 架构违规检测

- 分层违规（下层依赖上层）
- 循环依赖
- 过度耦合（高依赖度）
- 孤立模块

#### 3. Clean Architecture 符合性检查

- 领域层的独立性
- 基础设施层的适当分离
- 用例层的依赖方向
- 接口的应用情况

### 输出示例

```
依赖关系分析报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 指标概览
├─ 总模块数: 42
├─ 平均依赖数: 3.2
├─ 最大依赖深度: 5
└─ 循环依赖: 检测到 2 处

⚠️  架构违规
├─ [HIGH] src/domain/user.js → src/infra/database.js
│  └─ 领域层直接依赖基础设施层
├─ [MED] src/api/auth.js ⟲ src/services/user.js
│  └─ 检测到循环依赖
└─ [LOW] src/utils/helper.js → 12 modules
   └─ 过度扇出

✅ 推荐操作
1. 引入 UserRepository 接口
2. 重新设计认证服务的职责
3. 按功能拆分辅助函数

📈 依赖关系图
[使用 ASCII 艺术显示可视化的依赖关系图]
```

### 高级用法

```bash
# 在 CI/CD 流水线中进行自动检查
/dependency-analysis --circular --fail-on-violation

# 定义并验证架构规则
/dependency-analysis --rules .architecture-rules.yml

# 按时间序列追踪依赖关系的变化
/dependency-analysis --compare HEAD~10
```

### 配置文件示例 (.dependency-analysis.yml)

```yaml
rules:
  - name: "Domain Independence"
    source: "src/domain/**"
    forbidden: ["src/infra/**", "src/api/**"]

  - name: "API Layer Dependencies"
    source: "src/api/**"
    allowed: ["src/domain/**", "src/application/**"]
    forbidden: ["src/infra/**"]

thresholds:
  max_dependencies: 8
  max_depth: 4
  coupling_threshold: 0.7

ignore:
  - "**/test/**"
  - "**/mocks/**"
```

### 集成工具

- `madge` : 可视化 JavaScript/TypeScript 的依赖关系
- `dep-cruiser` : 验证依赖关系的规则
- `nx` : 管理 monorepo 的依赖关系
- `plato` : 综合分析复杂度和依赖关系

### 与 Claude 协作

```bash
# 包含 package.json 的分析
cat package.json
/analyze-dependencies
“请分析此项目的依赖关系问题”

# 结合特定模块的源代码
ls -la src/core/
/analyze-dependencies --focus src/core
“请详细评估核心模块的依赖关系”

# 与架构文档进行比较
cat docs/architecture.md
/analyze-dependencies --visual
“请确认设计文档与实现之间的差异”
```

### 注意事项

- **前提条件**: 需要在项目根目录下执行
- **限制**: 对于大型项目，分析可能需要一些时间
- **建议**: 如果发现循环依赖，请立即考虑处理

### 最佳实践

1. **定期分析**: 每周检查依赖关系的健康状况
2. **明确规则**: 在配置文件中管理架构规则
3. **分步改进**: 避免大规模重构，逐步进行改进
4. **指标追踪**: 按时间序列监控依赖关系的复杂度
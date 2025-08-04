## 技术债

分析项目的技术债，并创建优先级的改进计划。

### 使用方法

```bash
# 检查项目配置并分析技术债
ls -la
“请分析该项目的技术债并创建改进计划”
```

### 基本示例

```bash
# 分析 TODO/FIXME 注释
grep -r "TODO\|FIXME\|HACK\|XXX\|WORKAROUND" . --exclude-dir=node_modules --exclude-dir=.git
“请将这些 TODO 注释按优先级排序并制定改进计划”

# 检查项目依赖
ls -la | grep -E "package.json|Cargo.toml|pubspec.yaml|go.mod|requirements.txt"
“请分析项目依赖，找出过时的依赖及其风险”

# 检测大文件或复杂函数
find . -type f -not -path "*/\.*" -not -path "*/node_modules/*" -exec wc -l {} + | sort -rn | head -10
“请找出过大的文件或复杂结构，并提出改进建议”
```

### 与 Claude 协作

```bash
# 全面的技术债分析
ls -la && find . -name "*.md" -maxdepth 2 -exec head -20 {} \;
“请从以下角度分析该项目的技术债：
1. 代码质量（复杂度、重复、可维护性）
2. 依赖关系的健康状况
3. 安全风险
4. 性能问题
5. 测试覆盖率不足”

# 架构债分析
find . -type d -name "src" -o -name "lib" -o -name "app" | head -10 | xargs ls -la
“请找出架构层面的技术债，并提出重构计划”

# 优先级排序的改进计划
“请根据以下标准评估技术债，并以表格形式呈现：
- 影响程度（高/中/低）
- 修复成本（时间）
- 业务风险
- 改进带来的效果
- 建议实施时间”
```

### 详细示例

```bash
# 自动检测项目类型并分析
find . -maxdepth 2 -type f \( -name "package.json" -o -name "Cargo.toml" -o -name "pubspec.yaml" -o -name "go.mod" -o -name "pom.xml" \)
“请根据检测到的项目类型，分析以下内容：
1. 特定语言/框架的技术债
2. 与最佳实践的偏离
3. 现代化机会
4. 渐进式改进策略”

# 代码质量指标分析
find . -type f -name "*" | grep -E "\.(js|ts|py|rs|go|dart|kotlin|swift|java)$" | wc -l
“请分析项目的代码质量，并提供以下指标：
- 循环复杂度高的函数
- 重复代码检测
- 过长的文件/函数
- 缺乏适当的错误处理”

# 安全债检测
grep -r "password\|secret\|key\|token" . --exclude-dir=.git --exclude-dir=node_modules | grep -v ".env.example"
“请检测与安全相关的技术债，并提出修复优先级和对策”

# 测试不足分析
find . -type f \( -name "*test*" -o -name "*spec*" \) | wc -l && find . -type f -name "*.md" | xargs grep -l "test"
“请分析测试覆盖率的技术债，并提出测试策略”
```

### 注意事项

- 自动检测项目的语言和框架，并进行相应的分析
- 技术债分为“应立即修复的重要问题”和“长期改进项目”
- 提供兼顾业务价值和技术改进的现实计划
- 同时考虑改进带来的 ROI（投资回报率）
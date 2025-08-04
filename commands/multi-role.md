## 多角色

一个命令，让多个角色并行分析同一个对象，并生成综合报告。

### 使用方法

```bash
/multi-role <角色1>,<角色2> [--agent|-a] [分析对象]
/multi-role <角色1>,<角色2>,<角色3> [--agent|-a] [分析对象]
```

**重要**:

- `--agent` 选项请放在角色指定之后
- 消息请写在 `--agent` 之后
- 正确示例: `/multi-role qa,architect --agent 评估计划`
- 错误示例: `/multi-role qa,architect 评估计划 --agent`

### 选项

- `--agent` 或 `-a` : 每个角色作为子代理并行执行（建议在进行大规模分析时使用）
  - 使用此选项时，如果每个角色的描述中包含促进自动委派的短语（如“use PROACTIVELY”），则会启用更积极的自动委派

### 基本示例

```bash
# 同时进行安全和性能分析（常规）
/multi-role security,performance
“请评估此 API 端点”

# 大规模系统的并行分析（子代理）
/multi-role security,performance --agent
“全面分析整个系统的安全性和性能”

# 前端、移动端和性能的综合分析
/multi-role frontend,mobile,performance
“请探讨此画面的优化方案”

# 架构设计的多角度评估（子代理）
/multi-role architect,security,performance --agent
“请评估微服务化的设计”
```

### 分析过程

### 阶段 1: 并行分析

每个角色独立分析同一个对象

- 从专业角度执行评估
- 按角色特定的标准进行判断
- 生成独立的推荐事项

### 阶段 2: 综合分析

结构化并整合结果

- 整理每个角色的评估结果
- 识别重复和矛盾之处
- 明确互补关系

### 阶段 3: 综合报告

生成最终的推荐事项

- 带优先级的行动计划
- 明确权衡利弊
- 提出实施路线图

### 输出格式示例

### 两角色分析的情况

```
多角色分析: Security + Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

分析对象: API 端点 /api/users

Security 分析结果:
认证: JWT 验证已正确实现
授权: 基于角色的访问控制不完善
加密: API 密钥以明文形式输出到日志

评估分数: 65/100
重要性: High（因为涉及机密数据访问）

Performance 分析结果:
响应时间: 平均 180ms（目标 200ms 以内）
数据库查询: 检测到 N+1 问题
缓存: 未实现 Redis 缓存

评估分数: 70/100
重要性: Medium（目前在可接受范围内）

相互关联分析:
协同效应的机会:
- 在实现 Redis 缓存时同时考虑加密
- 改进日志输出可以同时提升安全性和性能

权衡点:
- 加强授权检查 ↔ 对响应时间的影响
- 日志加密 ↔ 调试效率的降低

综合优先级:
Critical: 修复 API 密钥明文输出
High: 解决 N+1 查询问题
Medium: 实现 Redis 缓存 + 加密
Low: 细化授权控制

实施路线图:
第 1 周: 实现 API 密钥的脱敏
第 2 周: 优化数据库查询
第 3-4 周: 设计并实现缓存层
第 2 个月: 分阶段加强授权控制
```

### 三角色分析的情况

```
多角色分析: Frontend + Mobile + Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

分析对象: 用户个人资料画面

Frontend 分析结果:
可用性: 布局直观
可访问性: WCAG 2.1 符合率 85%
响应式: 平板电脑显示存在问题

Mobile 分析结果:
触摸目标: 已确保 44pt 以上
单手操作: 重要按钮位于顶部
离线支持: 未实现

Performance 分析结果:
首次显示: LCP 2.1 秒（良好）
图片优化: 不支持 WebP
延迟加载: 未实现

综合推荐事项:
1. 移动端优化（单手操作 + 离线支持）
2. 图片优化（WebP + 延迟加载）
3. 改进平板电脑 UI

优先级: Mobile > Performance > Frontend
实施周期: 3-4 周
```

### 有效的组合模式

### 重视安全

```bash
/multi-role security,architect
“认证系统的设计”

/multi-role security,frontend  
“登录画面的安全性”

/multi-role security,mobile
“移动应用的数据保护”
```

### 重视性能

```bash
/multi-role performance,architect
“可扩展性设计”

/multi-role performance,frontend
“网页加速”

/multi-role performance,mobile
“应用性能优化”
```

### 重视用户体验

```bash
/multi-role frontend,mobile
“跨平台 UI”

/multi-role frontend,performance
“UX 与性能的平衡”

/multi-role mobile,performance
“移动 UX 优化”
```

### 全面分析

```bash
/multi-role architect,security,performance
“系统整体评估”

/multi-role frontend,mobile,performance
“用户体验综合评估”

/multi-role security,performance,mobile
“移动应用综合诊断”
```

### 与 Claude 协作

```bash
# 结合文件分析
cat src/components/UserProfile.tsx
/multi-role frontend,mobile
“请从多个角度评估此组件”

# 评估设计文档
cat architecture-design.md
/multi-role architect,security,performance
“请从多个专业领域评估此设计”

# 错误分析
cat performance-issues.log
/multi-role performance,analyzer
“请多角度分析性能问题”
```

### multi-role vs role-debate 的使用场景

### 使用 multi-role 的场景

- 希望获得各个专业领域的独立评估
- 希望制定综合性的改进计划
- 希望整理矛盾和重复之处
- 希望确定实施优先级

### 使用 role-debate 的场景

- 专业领域之间存在权衡
- 技术选型上可能存在分歧
- 希望通过辩论来决定设计方针
- 希望听取不同角度的辩论

### 子代理并行执行（--agent）

使用 `--agent` 选项时，每个角色将作为独立的子代理并行执行。

#### 促进自动委派

如果角色文件的 description 字段中包含以下短语，则在使用 `--agent` 时会启用更积极的自动委派：

- “use PROACTIVELY”
- “MUST BE USED”
- 其他强调性表达

#### 执行流程

```
常规执行:
角色 1 → 角色 2 → 角色 3 → 整合
（顺序执行，约 3-5 分钟）

--agent 执行:
角色 1 ─┐
角色 2 ─┼→ 整合
角色 3 ─┘
（并行执行，约 1-2 分钟）
```

#### 有效的使用示例

```bash
# 大规模系统的综合评估
/multi-role architect,security,performance,qa --agent
“对新系统进行全面评估”

# 多角度的详细分析
/multi-role frontend,mobile,performance --agent
“对所有画面进行 UX 优化分析”
```

#### 性能比较

| 角色数 | 常规执行 | --agent 执行 | 缩短率 |
|---|---|---|---|
| 2 角色 | 2-3 分钟 | 1 分钟 | 50% |
| 3 角色 | 3-5 分钟 | 1-2 分钟 | 60% |
| 4 角色 | 5-8 分钟 | 2-3 分钟 | 65% |

### 注意事项

- 同时执行 3 个以上角色会使输出变长
- 分析越复杂，执行时间可能越长
- 如果出现相互矛盾的推荐，请考虑使用 role-debate
- 最终决策请用户参考综合结果自行做出
- **使用 --agent 时**: 会使用更多资源，但在大规模分析时更高效
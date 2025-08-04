## 角色帮助

当您不确定该使用哪个角色时，此功能可作为选择指南和帮助系统。

### 使用方法

```bash
/role-help                      # 常规角色选择指南
/role-help <情况/问题>          # 针对特定情况推荐角色
/role-help compare <角色1>,<角色2> # 比较角色
```

### 基本示例

```bash
# 一般指导
/role-help
→ 显示可用角色及其特点列表

# 根据情况推荐
/role-help “担心 API 的安全性”
→ 推荐 security 角色及其使用方法

# 比较角色
/role-help compare frontend,mobile
→ frontend 和 mobile 的区别和使用场景
```

### 按情况选择角色的指南

### 安全相关

```
在这种情况下使用 security 角色：
✅ 实现登录/认证功能
✅ 检查 API 的安全漏洞
✅ 数据加密/隐私保护
✅ 确认安全合规性
✅ 入侵测试/渗透测试

使用方法: /role security
```

### 🏗️ 架构/设计

```
在这种情况下使用 architect 角色：
✅ 评估整个系统的设计
✅ 判断使用微服务还是单体架构
✅ 数据库设计/技术选型
✅ 考虑可扩展性/可伸缩性
✅ 评估技术债务/制定改进计划

使用方法: /role architect
```

### ⚡ 性能问题

```
在这种情况下使用 performance 角色：
✅ 应用程序运行缓慢
✅ 优化数据库查询
✅ 改善网页加载速度
✅ 优化内存/CPU 使用率
✅ 扩展/负载对策

使用方法: /role performance
```

### 🔍 问题原因调查

```
在这种情况下使用 analyzer 角色：
✅ 分析 bug/错误的根本原因
✅ 查明系统故障的原因
✅ 结构化分析复杂问题
✅ 数据分析/统计调查
✅ 查明问题发生的原因

使用方法: /role analyzer
```

### 🎨 前端/UI/UX

```
在这种情况下使用 frontend 角色：
✅ 改善用户界面
✅ 实现可访问性
✅ 响应式设计
✅ 提高可用性/易用性
✅ 所有 Web 前端技术

使用方法: /role frontend
```

### 📱 移动应用开发

```
在这种情况下使用 mobile 角色：
✅ 优化 iOS/Android 应用
✅ 移动端特有的 UX 设计
✅ 优化触摸界面
✅ 离线支持/同步功能
✅ 应对 App Store/Google Play

使用方法: /role mobile
```

### 👀 代码审查/质量

```
在这种情况下使用 reviewer 角色：
✅ 检查代码质量
✅ 评估可读性/可维护性
✅ 确认编码规范
✅ 提出重构建议
✅ 审查 PR/提交

使用方法: /role reviewer
```

### 🧪 测试/质量保证

```
在这种情况下使用 qa 角色：
✅ 制定测试策略
✅ 评估测试覆盖率
✅ 自动化测试的实施方针
✅ 预防 bug/提高质量的措施
✅ 在 CI/CD 中实现测试自动化

使用方法: /role qa
```

### 需要多个角色时

### 🔄 multi-role (并行分析)

```
在这种情况下使用 multi-role：
✅ 希望从多个专业角度进行评估
✅ 希望制定综合性的改进计划
✅ 希望比较各个领域的评估
✅ 希望整理矛盾/重复之处

示例: /multi-role security,performance
```

### 🗣️ role-debate (辩论)

```
在这种情况下使用 role-debate：
✅ 专业领域之间存在权衡
✅ 技术选型上意见不一
✅ 希望通过辩论决定设计方针
✅ 希望听取不同视角的辩论

示例: /role-debate security,performance
```

### 🤖 smart-review (自动推荐)

```
在这种情况下使用 smart-review：
✅ 不知道该使用哪个角色
✅ 希望了解当前情况下的最佳方法
✅ 希望从多个选项中进行选择
✅ 作为初学者，在判断上犹豫不决

示例: /smart-review
```

### 角色比较表

### 安全类

| 角色 | 主要用途 | 擅长领域 | 不擅长领域 |
|---|---|---|---|
| security | 漏洞/攻击对策 | 威胁分析、认证设计 | UX、性能 |
| analyzer | 根本原因分析 | 逻辑分析、证据收集 | 预防措施、未来计划 |

### 设计类

| 角色 | 主要用途 | 擅长领域 | 不擅长领域 |
|---|---|---|---|
| architect | 系统设计 | 长期视角、整体优化 | 详细实现、短期解决方案 |
| reviewer | 代码质量 | 实现层面、可维护性 | 业务需求、UX |

### 性能类

| 角色 | 主要用途 | 擅长领域 | 不擅长领域 |
|---|---|---|---|
| performance | 加速/优化 | 测量、瓶颈 | 安全、UX |
| qa | 质量保证 | 测试、自动化 | 设计、架构 |

### 用户体验类

| 角色 | 主要用途 | 擅长领域 | 不擅长领域 |
|---|---|---|---|
| frontend | Web UI/UX | 浏览器、可访问性 | 服务器端、数据库 |
| mobile | 移动 UX | 触摸、离线支持 | 服务器端、Web |

### 犹豫不决时的流程图

```
问题性质是什么？
├─ 安全相关 → security
├─ 性能问题 → performance  
├─ bug/故障调查 → analyzer
├─ UI/UX 改善 → frontend or mobile
├─ 设计/架构 → architect
├─ 代码质量 → reviewer
├─ 测试相关 → qa
└─ 复合/复杂 → 使用 smart-review 推荐

是否涉及多个领域？
├─ 希望进行综合分析 → multi-role
├─ 存在辩论/权衡 → role-debate
└─ 判断犹豫不决 → smart-review
```

### 常见问题

### Q: frontend 和 mobile 有什么区别？

```
A: 
frontend: 以 Web 浏览器为中心，HTML/CSS/JavaScript
mobile: 以移动应用为中心，iOS/Android 原生、React Native 等

如果两者都相关，推荐使用 multi-role frontend,mobile
```

### Q: security 和 analyzer 如何区分使用？

```
A:
security: 预防攻击/威胁，安全设计
analyzer: 分析已发生问题的原因，进行调查

如果是调查安全事件，推荐使用 multi-role security,analyzer
```

### Q: architect 和 performance 有什么区别？

```
A:
architect: 整个系统的长期设计，可扩展性
performance: 具体的速速/效率改善

如果是大规模系统的性能设计，推荐使用 multi-role architect,performance
```

### 与 Claude 协作

```bash
# 结合情况说明
/role-help
“React 应用的页面加载很慢，收到了用户的投诉”

# 结合文件内容
cat problem-description.md
/role-help
“请为这个问题推荐最合适的角色”

# 在特定选项上犹豫不决时
/role-help compare security,performance
“对于 JWT 令牌的有效期问题，哪个角色更合适？”
```

### 注意事项

- 问题越复杂，组合多个角色越有效
- 紧急性高的情况下，使用 single role 快速响应
- 犹豫不决时，建议使用 smart-review 获取自动推荐
- 最终判断请用户根据问题性质自行决定
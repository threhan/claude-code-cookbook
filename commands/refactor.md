## 重构

安全、分阶段地进行代码重构，并评估 SOLID 原则的遵守情况。

### 使用方法

```bash
# 识别复杂代码并制定重构计划
find . -name "*.js" -exec wc -l {} + | sort -rn | head -10
“请重构大文件以降低其复杂性”

# 检测并整合重复代码
grep -r "function processUser" . --include="*.js"
“请使用‘提取方法’将重复的函数通用化”

# 检测违反 SOLID 原则的情况
grep -r "class.*Service" . --include="*.js" | head -10
“请评估这些类是否遵循单一职责原则”
```

### 基本示例

```bash
# 检测长方法
grep -A 50 "function" src/*.js | grep -B 50 -A 50 "return" | wc -l
“请使用‘提取方法’分割超过 50 行的方法”

# 条件分支的复杂性
grep -r "if.*if.*if" . --include="*.js"
“请使用策略模式改进嵌套的条件语句”

# 检测代码异味
grep -r "TODO\|FIXME\|HACK" . --exclude-dir=node_modules
“请解决构成技术债务的注释”
```

### 重构技巧

#### 提取方法

```javascript
// Before: 长方法
function processOrder(order) {
  // 50 行的复杂处理
}

// After: 职责分离
function processOrder(order) {
  validateOrder(order);
  calculateTotal(order);
  saveOrder(order);
}
```

#### 以多态取代条件

```javascript
// Before: switch 语句
function getPrice(user) {
  switch (user.type) {
    case 'premium': return basPrice * 0.8;
    case 'regular': return basePrice;
  }
}

// After: 策略模式
class PremiumPricing {
  calculate(basePrice) { return basePrice * 0.8; }
}
```

### SOLID 原则检查

```
S - 单一职责
├─ 每个类只承担一个职责
├─ 变更的原因只有一个
└─ 职责边界清晰

O - 开闭原则
├─ 对扩展开放
├─ 对修改关闭
└─ 添加新功能时保护现有代码

L - 里氏替换原则
├─ 派生类可替换基类
├─ 遵守契约
└─ 维持预期行为

I - 接口隔离原则
├─ 适当粒度的接口
├─ 避免依赖不使用的方法
└─ 按角色定义接口

D - 依赖倒置原则
├─ 依赖抽象
├─ 与具体实现分离
└─ 利用依赖注入
```

### 重构步骤

1. **现状分析**
   - 复杂度测量（圈复杂度）
   - 检测重复代码
   - 分析依赖关系

2. **分阶段执行**
   - 小步快跑（15-30 分钟为单位）
   - 每次变更后运行测试
   - 频繁提交

3. **质量确认**
   - 维持测试覆盖率
   - 性能测量
   - 代码审查

### 常见的代码异味

- **上帝对象**: 承担过多职责的类
- **长方法**: 超过 50 行的长方法
- **重复代码**: 相同逻辑的重复
- **大类**: 超过 300 行的大类
- **长参数列表**: 超过 4 个参数

### 自动化支持

```bash
# 静态分析
npx complexity-report src/
sonar-scanner

# 代码格式化
npm run lint:fix
prettier --write src/

# 运行测试
npm test
npm run test:coverage
```

### 注意事项

- **禁止功能变更**: 不改变外部行为
- **测试先行**: 重构前添加测试
- **分阶段方法**: 不要一次进行大的变更
- **持续验证**: 每一步都运行测试
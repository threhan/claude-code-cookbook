## 设计模式

提出适用于代码库的设计模式，并评估 SOLID 原则的遵守情况。

### 使用方法

```bash
/design-patterns [分析对象] [选项]
```

### 选项

- `--suggest` : 提出适用的模式（默认）
- `--analyze` : 分析现有模式的使用情况
- `--refactor` : 生成重构方案
- `--solid` : 检查 SOLID 原则的遵守情况
- `--anti-patterns` : 检测反模式

### 基本示例

```bash
# 分析整个项目的模式
/design-patterns

# 为特定文件提出模式建议
/design-patterns src/services/user.js --suggest

# 检查 SOLID 原则
/design-patterns --solid

# 检测反模式
/design-patterns --anti-patterns
```

### 分析类别

#### 1. 创建型模式

- **工厂模式**: 抽象化对象创建
- **生成器模式**: 分步构建复杂对象
- **单例模式**: 保证实例的唯一性
- **原型模式**: 克隆生成对象

#### 2. 结构型模式

- **适配器模式**: 转换接口
- **装饰器模式**: 动态添加功能
- **外观模式**: 简化复杂子系统
- **代理模式**: 控制对对象的访问

#### 3. 行为型模式

- **观察者模式**: 实现事件通知
- **策略模式**: 切换算法
- **命令模式**: 封装操作
- **迭代器模式**: 遍历集合

### SOLID 原则检查项

```
S - 单一职责原则
O - 开闭原则
L - 里氏替换原则
I - 接口隔离原则
D - 依赖倒置原则
```

### 输出示例

```
设计模式分析报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

当前使用的模式
├─ 观察者模式: EventEmitter (12 处)
├─ 工厂模式: UserFactory (3 处)
├─ 单例模式: DatabaseConnection (1 处)
└─ 策略模式: PaymentProcessor (5 处)

推荐模式
├─ [HIGH] 仓库模式
│  └─ 对象: src/models/*.js
│  └─ 原因: 分离数据访问逻辑
│  └─ 示例:
│      class UserRepository {
│        async findById(id) { ... }
│        async save(user) { ... }
│      }
│
├─ [MED] 命令模式
│  └─ 对象: src/api/handlers/*.js
│  └─ 原因: 统一请求处理
│
└─ [LOW] 装饰器模式
   └─ 对象: src/middleware/*.js
   └─ 原因: 改进功能组合

违反 SOLID 原则
├─ [S] UserService: 同时负责认证和权限管理
├─ [O] PaymentGateway: 添加新支付方式时需要修改
├─ [D] EmailService: 直接依赖具体类
└─ [I] IDataStore: 包含未使用的方法

重构建议
1. 将 UserService 分为认证和权限管理
2. 引入 PaymentStrategy 接口
3. 定义 EmailService 接口
4. 按用途分离 IDataStore
```

### 高级用法

```bash
# 分析模式应用的影响
/design-patterns --impact-analysis Repository

# 生成特定模式的实现示例
/design-patterns --generate Factory --for src/models/Product.js

# 提出模式组合建议
/design-patterns --combine --context "API with caching"

# 评估架构模式
/design-patterns --architecture MVC
```

### 模式应用示例

#### Before (有问题的代码)

```javascript
class OrderService {
  processOrder(order, paymentType) {
    if (paymentType === "credit") {
      // 信用卡处理
    } else if (paymentType === "paypal") {
      // PayPal 处理
    }
    // 其他支付方式...
  }
}
```

#### After (应用策略模式)

```javascript
// 策略接口
class PaymentStrategy {
  process(amount) {
    throw new Error("Must implement process method");
  }
}

// 具体策略
class CreditCardPayment extends PaymentStrategy {
  process(amount) {
    /* 实现 */
  }
}

// 上下文
class OrderService {
  constructor(paymentStrategy) {
    this.paymentStrategy = paymentStrategy;
  }

  processOrder(order) {
    this.paymentStrategy.process(order.total);
  }
}
```

### 反模式检测

- **上帝对象**: 承担过多职责的类
- **面条代码**: 控制流复杂交错的代码
- **复制粘贴编程**: 过度使用重复代码
- **魔术数字**: 硬编码的常量
- **回调地狱**: 深度嵌套的回调

### 最佳实践

1. **分步应用**: 不要一次应用太多模式
2. **验证必要性**: 模式是解决问题的手段，而不是目的
3. **团队共识**: 应用模式前与团队讨论
4. **文档化**: 记录所应用模式的意图
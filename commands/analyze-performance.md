## 分析性能

分析应用程序的性能问题，并从技术债务的角度提出改进建议。

### 使用方法

```bash
# 全面分析性能问题
find . -name "*.js" -o -name "*.ts" | xargs wc -l | sort -rn | head -10
“请找出大文件和性能问题，并提出改进建议”

# 检测低效的代码模式
grep -r "for.*await\|forEach.*await" . --include="*.js"
“请分析 N+1 查询问题和性能瓶颈”

# 内存泄漏的可能性
grep -r "addEventListener\|setInterval" . --include="*.js" | grep -v "removeEventListener\|clearInterval"
“请评估内存泄漏的风险和对策”
```

### 基本示例

```bash
# 打包大小和加载时间
npm ls --depth=0 && find ./public -name "*.js" -o -name "*.css" | xargs ls -lh
“请找出打包大小和资源优化的改进点”

# 数据库性能
grep -r "SELECT\|findAll\|query" . --include="*.js" | head -20
“请分析数据库查询的优化点”

# 依赖项的性能影响
npm outdated && npm audit
“请评估过时的依赖项对性能的影响”
```

### 分析角度

#### 1. 代码层面的问题

- **O(n²) 算法**: 检测低效的数组操作
- **同步 I/O**: 识别阻塞操作
- **重复处理**: 删除不必要的计算或请求
- **内存泄漏**: 管理事件监听器和计时器

#### 2. 架构层面的问题

- **N+1 查询**: 数据库访问模式
- **缓存不足**: 重复计算或 API 调用
- **打包大小**: 不必要的库或代码拆分
- **资源管理**: 连接池或线程使用量

#### 3. 技术债务的影响

- **遗留代码**: 旧实现导致的性能下降
- **设计问题**: 职责分散不足导致的高耦合度
- **测试不足**: 性能回归的检测遗漏
- **监控不足**: 问题早期发现机制

### 改进优先级

```
🔴 Critical: 系统故障风险
├─ 内存泄漏 (服务器崩溃)
├─ N+1 查询 (数据库负载)
└─ 同步 I/O (响应延迟)

🟡 High: 影响用户体验
├─ 打包大小 (首次加载时间)
├─ 图片优化 (显示速度)
└─ 缓存策略 (反应速度)

🟢 Medium: 运维效率
├─ 依赖项更新 (安全性)
├─ 代码重复 (可维护性)
└─ 加强监控 (运维负载)
```

### 测量和工具

#### Node.js / JavaScript

```bash
# 性能分析
node --prof app.js
clinic doctor -- node app.js

# 打包分析
npx webpack-bundle-analyzer
lighthouse --chrome-flags="--headless"
```

#### 数据库

```sql
-- 查询分析
EXPLAIN ANALYZE SELECT ...
SHOW SLOW LOG;
```

#### 前端

```bash
# React 性能
grep -r "useMemo\|useCallback" . --include="*.jsx"

# 资源分析
find ./src -name "*.png" -o -name "*.jpg" | xargs ls -lh
```

### 持续改进

- **定期审计**: 每周执行性能测试
- **指标收集**: 跟踪响应时间和内存使用量
- **警报设置**: 阈值超标时自动通知
- **团队共享**: 将改进案例和反模式文档化
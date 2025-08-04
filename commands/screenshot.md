## 屏幕截图

在 macOS 上截取屏幕截图并分析图像。

### 使用方法

```bash
/screenshot [选项]
```

### 选项

- 无：选择窗口（Claude 会确认选项）
- `--window`：指定窗口进行截图
- `--full`：截取整个屏幕
- `--crop`：选择范围进行截图

### 基本示例

```bash
# 截取窗口并分析
/screenshot --window
“请分析截取的屏幕”

# 选择范围并分析
/screenshot --crop
“请说明所选范围的内容”

# 截取全屏并分析
/screenshot --full
“请分析整个屏幕的构成”
```

### 与 Claude 协作

```bash
# 无特定问题 - 情况分析
/screenshot --crop
（Claude 会自动分析屏幕内容，并说明元素和构成）

# UI/UX 问题分析
/screenshot --window
“请提出此 UI 的问题点和改进建议”

# 错误分析
/screenshot --window
“请告诉我此错误消息的原因和解决方法”

# 设计审查
/screenshot --full
“请从 UX 的角度评估此设计”

# 代码分析
/screenshot --crop
“请指出此代码的问题点”

# 数据可视化分析
/screenshot --crop
“请分析从此图表中可以看出的趋势”
```

### 详细示例

```bash
# 从多个角度进行分析
/screenshot --window
“请分析此屏幕的以下几点：
1. UI 的一致性
2. 可访问性问题
3. 改进建议”

# 为比较分析截取多张截图
/screenshot --window
# （保存 before 的图像）
# 进行更改
/screenshot --window
# （保存 after 的图像）
“请比较 before 和 after 的图像，并分析变更点和改进效果”

# 聚焦特定元素
/screenshot --crop
“请评估所选按钮的设计是否与其他元素协调”
```

### 禁止事项

- **禁止在未截取屏幕截图的情况下说“已截取”**
- **禁止尝试分析不存在的图像文件**
- **`/screenshot` 命令不执行实际的屏幕截图**

### 注意事项

- 如果未指定选项，请提示以下选项：

  ```
  “您想用哪种方式截取屏幕截图？
  1. 选择窗口 (--window) → screencapture -W
  2. 整个屏幕 (--full) → screencapture -x
  3. 选择范围 (--crop) → screencapture -i”
  ```

- 请在用户执行 `screencapture` 命令后开始图像分析
- 指定具体问题或角度可以进行更有针对性的分析
# 快速开始指南

本指南将帮助你在 5 分钟内完成 ROOT 文件预览插件的安装和配置。

## 前置要求

在开始之前，请确保你已经：

1. **安装了 Yazi 文件管理器**
   ```bash
   # 检查 yazi 是否已安装
   yazi --version
   ```

2. **安装了 ROOT 框架**
   ```bash
   # 检查 rootls 是否可用
   which rootls
   # 检查 rootbrowse 是否可用
   which rootbrowse
   ```

   如果还没有安装 ROOT：
   - **macOS**: `brew install root`
   - **Linux**: 访问 https://root.cern/install/

## 安装插件

### 使用 Yazi 包管理器（推荐）

```bash
# 从 GitHub 仓库安装
ya pkg add https://github.com/chenxu7/root-preview.yazi

# 或者从本地克隆的仓库安装
cd /path/to/root-preview.yazi
ya pkg add .
```

### 手动安装

```bash
# 复制插件到 Yazi 配置目录
cp -r root-preview.yazi ~/.config/yazi/plugins/
```

## 配置 Yazi

### 最简配置

将以下内容添加到 `~/.config/yazi/yazi.toml` 文件的末尾：

```toml
[[plugin.prepend_previewers]]
name = "*.root"
run = "root-preview"
```

### 完整配置示例

如果你想要更详细的配置，可以在 `yazi.toml` 中添加：

```toml
[preview]
# 其他预览设置...
wrap = "no"
max_width = 600
max_height = 900

# 添加 ROOT 文件预览规则
[[plugin.prepend_previewers]]
name = "*.root"
run = "root-preview"
```

## 验证安装

### 1. 测试 ROOT 工具

首先确保 ROOT 命令行工具正常工作：

```bash
# 测试 rootls（预览功能）
rootls -t -r your_file.root

# 测试 rootbrowse（打开功能）
rootbrowse your_file.root
```

参数说明：
- `-t`: 树状结构显示
- `-r`: 显示详细信息

### 2. 启动 Yazi

```bash
# 正常启动
yazi

# 或启用调试日志（如果遇到问题）
YAZI_LOG=debug yazi
```

### 3. 测试预览功能

1. 在 Yazi 中导航到一个包含 `.root` 文件的目录
2. 使用方向键移动到 `.root` 文件上
3. 右侧预览面板应该自动显示 ROOT 文件的内部结构

### 4. 测试打开功能

1. 在 `.root` 文件上按 `Enter` 键
2. 应该会打开 ROOT 浏览器，显示交互式界面
3. 退出 ROOT 浏览器后会自动返回 Yazi

## 使用技巧

### 预览大文件

对于大型 ROOT 文件：
- 使用 `Ctrl+j` / `Ctrl+k` 逐行滚动
- 使用 `Ctrl+u` / `Ctrl+d` 页面滚动
- 使用鼠标滚轮快速浏览

### 键盘快捷键

| 快捷键 | 功能 |
|--------|------|
| `Enter` | 在 ROOT 浏览器中打开文件 |
| `q` | 退出 ROOT 浏览器 |
| `Ctrl+j/k` | 上下滚动预览 |
| `Ctrl+u/d` | 页面滚动 |

### 常用命令

```bash
# 检查插件是否正确安装
ls ~/.config/yazi/plugins/root-preview.yazi

# 查看 Yazi 日志
tail -f ~/.local/state/yazi/yazi.log

# 测试 rootls 命令
rootls -t -r file.root
```

## 常见问题

### Q: 预览不显示任何内容

**A:** 按以下步骤检查：

1. 确认 rootls 已安装：
   ```bash
   which rootls
   ```

2. 测试命令：
   ```bash
   rootls -t -r your_file.root
   ```

3. 检查配置文件：
   ```bash
   cat ~/.config/yazi/yazi.toml | grep -A 2 root
   ```

4. 查看日志：
   ```bash
   YAZI_LOG=debug yazi
   # 然后在另一个终端查看日志
   grep "root" ~/.local/state/yazi/yazi.log
   ```

### Q: 按 Enter 打开文件时出错

**A:** 这通常是因为 `rootbrowse` 不可用：

```bash
# 检查 rootbrowse
which rootbrowse

# 如果不存在，请重新安装 ROOT
# macOS:
brew reinstall root
```

### Q: 预览显示乱码或奇怪的颜色

**A:** 插件会自动清理 ANSI 颜色代码。如果仍有问题：

1. 测试 rootls 的原始输出：
   ```bash
   rootls -t -r your_file.root | cat -A
   ```

2. 检查是否有其他预处理问题：
   ```bash
   rootls -t -r your_file.root > /tmp/test.txt
   cat /tmp/test.txt
   ```

### Q: 如何调整预览参数？

**A:** 编辑 `main.lua` 文件，找到第 40 行：

```lua
local output, err = Command("rootls"):arg({ "-t", "-r", file }):output()
```

可以修改为：
- `{ "-t", "-r", file }` - 树状结构 + 详细信息（默认）
- `{ "-l", file }` - 简单列表
- `{ file }` - 最简输出

### Q: 大文件预览很慢

**A:** 插件已经实现了智能缓存。首次预览时会慢一些，但后续浏览会很快。

如果仍然慢，可以：
1. 减少输出信息：修改命令参数为 `-t`（只显示树状结构）
2. 检查磁盘 I/O 性能
3. 查看 ROOT 文件是否损坏

### Q: 插件更新后如何重启？

**A:**

```bash
# 如果使用包管理器
ya pkg install https://github.com/chenxu7/root-preview.yazi

# 然后重启 yazi
# Yazi 会在启动时自动加载新版本
```

## 下一步

- 阅读完整的 [README.md](README.md) 了解更多功能
- 查看 [Yazi 官方文档](https://yazi-rs.github.io/) 学习更多插件
- 访问 [ROOT 官方文档](https://root.cern/) 深入学习 ROOT 框架

## 获取帮助

如果遇到问题：

1. 查看 Yazi 日志：`~/.local/state/yazi/yazi.log`
2. 测试 ROOT 命令是否正常工作
3. 在 GitHub 上提交 Issue：https://github.com/chenxu7/root-preview.yazi/issues

## 插件版本

当前版本: **0.1.0**

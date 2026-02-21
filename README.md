# ROOT File Preview Plugin for Yazi

这是一个用于 Yazi 文件管理器的 ROOT 文件预览插件，使用 `rootls` 命令来预览 CERN ROOT 框架的 `.root` 文件。

## 功能特性

- 🔍 **预览 ROOT 文件** - 自动显示 ROOT 文件的内部结构（树状视图）
- 📜 **优化滚动** - 智能缓存和分页，提供流畅的大文件滚动体验
- 🚀 **快速打开** - 直接在 ROOT 浏览器中打开文件进行交互式浏览
- 💾 **智能缓存** - 自动缓存文件内容，避免重复执行命令
- 🎨 **自动清理** - 自动清理 ANSI 颜色代码，确保预览清晰可读

## 安装

### 方法 1: 使用 Yazi 包管理器（推荐）

```bash
# 从 git 仓库安装
ya pkg add cxwx/root-preview
```

### 方法 2: 手动安装

```bash
# 将插件复制到你的 yazi 配置目录
cp -r root-preview.yazi ~/.config/yazi/plugins/root-preview.yazi
```

## 配置

在你的 `~/.config/yazi/yazi.toml` 文件中添加以下配置：

```toml
[[plugin.prepend_previewers]]
name = "*.root"
run = "root-preview"
```

## 依赖

本插件需要以下工具：

- [ROOT](https://root.cern/) - CERN 的数据分析框架
- `rootls` - 用于列出 ROOT 文件内容（预览功能）
- `rootbrowse` - 用于在 ROOT 浏览器中打开文件（entry 功能）

### 安装 ROOT

**macOS (使用 Homebrew):**
```bash
brew install root
```

**Linux:**
```bash
# 请参考 ROOT 官方文档
# https://root.cern/install/
```

**验证安装:**
```bash
# 检查 rootls
which rootls
rootls --version

# 检查 rootbrowse
which rootbrowse
```

## 使用方法

### 1. 预览 ROOT 文件 (Peek)

在 Yazi 中浏览到 `.root` 文件时，右侧预览面板会自动显示 ROOT 文件的内部结构。

插件会调用 `rootls -t -r` 命令：
- `-t`: 以树状结构显示
- `-r`: 显示详细信息（类型、大小等）

### 2. 滚动浏览 (Seek)

对于大型 ROOT 文件，可以使用 Yazi 的标准滚动键浏览预览内容：
- `Ctrl+j` / `Ctrl+k`: 上下滚动
- `Ctrl+u` / `Ctrl+d`: 页面滚动
- 鼠标滚轮: 滚动浏览

### 3. 在 ROOT 浏览器中打开 (Entry)

按 `Enter` 键直接在 ROOT 浏览器中打开文件，进行交互式浏览和数据分析。

## 预览效果示例

ROOT 文件的预览会显示类似这样的结构：

```
TFile:		histograms.root	root-example.root
TKey:		MyHits;1	TH1F "Histogram"
TKey:		hPx;1		TH1F "Momentum X"
TKey:		hPy;1		TH1F "Momentum Y"
TKey:		myTree;1	TTree "Event Tree"
  TBranch:	event	Int_t	event
  TBranch:	px	Float_t	px
  TBranch:	py	Float_t	py
  TBranch:	pz	Float_t	pz
```

## 功能说明

### Peek 预览功能
- 自动识别 `.root` 文件扩展名
- 使用智能缓存机制，避免重复执行 `rootls`
- 支持分页显示，大文件也能流畅预览
- 自动清理 ANSI 颜色代码

### Seek 滚动功能
- 优化的大文件滚动体验
- 保持预览位置，避免闪烁
- 智能边界检测

### Entry 打开功能
- 使用 `rootbrowse` 在 ROOT 浏览器中打开文件
- 完整的交互式数据分析环境
- 自动处理终端界面切换

## 故障排除

如果预览不工作：

### 1. 确认 ROOT 工具已安装

```bash
# 检查 rootls
which rootls

# 检查 rootbrowse
which rootbrowse
```

### 2. 测试命令是否正常工作

```bash
# 测试预览命令
rootls -t -r your_file.root

# 测试浏览器命令
rootbrowse your_file.root
```

### 3. 检查 Yazi 日志

```bash
# 启用调试模式
YAZI_LOG=debug yazi

# 查看日志
grep "root" ~/.local/state/yazi/yazi.log
```

### 4. 常见问题

**Q: 预览显示 "rootls command not found"**
A: 请确保已安装 ROOT 框架，并且 `rootls` 在 PATH 中

**Q: 按 Enter 打开文件时出错**
A: 请确保 `rootbrowse` 命令可用

**Q: 预览显示乱码**
A: 插件会自动清理 ANSI 颜色代码。如果仍有问题，请检查 `rootls` 的输出格式

## 开发

### 项目结构

```
root-preview.yazi/
├── main.lua           # 主插件代码
├── README.md          # 本文档
└── QUICKSTART.md      # 快速开始指南
```

### 插件接口

插件实现了 Yazi 的三个标准预览器接口：

- `peek(job)` - 预览文件内容
- `seek(job)` - 处理滚动事件
- `entry(job)` - 处理打开文件事件

## 版本

当前版本: **0.1.0**

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 作者

GLM-5 @ claude

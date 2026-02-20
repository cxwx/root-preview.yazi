# ROOT File Preview Plugin for Yazi

这是一个用于 Yazi 文件管理器的 ROOT 文件预览插件，使用 `rootls` 命令来预览 CERN ROOT 框架的 `.root` 文件。

## 功能

- 支持 `.root` 文件格式的预览
- 使用 `rootls -ctRr` 命令显示 ROOT 文件的目录树结构
- 自动识别 `.root` 扩展名

## 安装

### 方法 1: 使用 Yazi 包管理器（推荐）

```bash
# 从 git 仓库安装
ya pkg add https://github.com/你的用户名/yazi

# 或者如果是本地的 git 仓库
ya pkg add /path/to/this/repo
```

### 方法 2: 手动安装

```bash
# 将插件复制到你的 yazi 配置目录
cp -r root-preview.yazi ~/.config/yazi/plugins/root-preview.yazi
```

## 配置

在你的 `~/.config/yazi/yazi.toml` 文件中添加以下配置：

```toml
[preview]
# 添加 ROOT 文件预览规则
rules = [
    # ROOT 文件预览（在现有的 rules 数组中添加）
    { name = "*.root", use = "root-preview" },
]

# 添加预览器定义
[preview.previewers]
# ROOT 文件预览器
root-preview = "root-preview"
```

或者更简单的方式，在你的 `yazi.toml` 中添加：

```toml
[[plugin.prepend_previewers]]
name = "*.root"
run = "root-preview"
```

## 依赖

- [ROOT](https://root.cern/) - CERN 的数据 analysis 框架
- `rootls` 命令需要安装并可在 PATH 中访问

### 安装 ROOT

在 macOS 上使用 Homebrew:
```bash
brew install root
```

在 Linux 上:
```bash
# 查看 ROOT 官方文档获取安装说明
# https://root.cern/install/
```

## 使用

安装并配置后，在 yazi 中浏览到 `.root` 文件时，右侧预览面板会自动显示 ROOT 文件的内部结构。

插件会自动调用 `rootls -ctRr` 命令来显示文件内容：
- `-c`: 彩色输出（会被插件自动清理）
- `-t`: 树状结构
- `-R`: 递归显示
- `-r`: 详细信息

## 预览效果

例如，ROOT 文件的预览会显示：
```
myfile.root
├── TTree;1 "MyTree"
│   ├── Branch: event (Int_t)
│   ├── Branch: x (Float_t)
│   └── Branch: y (Float_t)
└── TH1F;1 "histogram"
```

## 故障排除

如果预览不工作：

1. 确认 `rootls` 已安装：
   ```bash
   which rootls
   ```

2. 测试命令是否正常工作：
   ```bash
   rootls -ctRr your_file.root
   ```

3. 检查 yazi 日志是否有错误信息：
   ```bash
   YAZI_LOG=debug yazi
   # 然后检查日志
   grep "ROOT" ~/.local/state/yazi/yazi.log
   ```

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

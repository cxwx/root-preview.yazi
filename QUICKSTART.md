# 快速开始

## 安装

使用 Yazi 包管理器 `ya` 安装：

```bash
# 从 git 仓库安装
ya pkg add https://github.com/你的用户名/yazi

# 或从本地仓库安装
cd /path/to/this/repo
ya pkg add .
```

## 最简配置

将以下内容添加到你的 `~/.config/yazi/yazi.toml` 文件的末尾：

```toml
[[plugin.prepend_previewers]]
name = "*.root"
run = "root-preview"
```

## 完整配置示例

如果你的 `yazi.toml` 还没有这些部分，可以添加完整的配置：

```toml
[preview]
wrap = "no"
max_width = 600
max_height = 900

[[preview.rules]]
# ... 其他规则 ...

# ROOT 文件预览（添加这个）
name = "*.root"
use = "root-preview"
```

## 验证安装

1. 确保 rootls 已安装：
```bash
which rootls
```

2. 测试预览命令：
```bash
rootls -ctRr your_file.root
```

3. 重启 yazi，导航到一个 .root 文件查看预览

## 常见问题

**Q: 预览不工作**
A: 检查 yazi 日志：
   ```bash
   YAZI_LOG=debug yazi
   grep "ROOT" ~/.local/state/yazi/yazi.log
   ```

**Q: 如何调整预览参数**
A: 可以修改 `main.lua` 文件中的 `rootls` 命令参数，例如：
- `rootls -ctR` （不带额外详细信息的树状结构）
- `rootls -l` （简单列表）

**Q: 预览显示乱码**
A: 插件会自动清理 ANSI 颜色代码。如果仍有问题，请检查 rootls 的输出格式。

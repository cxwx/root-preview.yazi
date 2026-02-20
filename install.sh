#!/bin/bash
# ROOT Preview Plugin for Yazi - 安装脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 配置目录
YAZI_CONFIG_DIR="${YAZI_CONFIG_DIR:-$HOME/.config/yazi}"
PLUGINS_DIR="$YAZI_CONFIG_DIR/plugins"
PLUGIN_NAME="root-preview.yazi"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}ROOT Preview Plugin for Yazi${NC}"
echo "======================================"
echo ""

# 检查 yazi 配置目录
if [ ! -d "$YAZI_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Creating yazi config directory: $YAZI_CONFIG_DIR${NC}"
    mkdir -p "$YAZI_CONFIG_DIR"
fi

# 创建插件目录
if [ ! -d "$PLUGINS_DIR" ]; then
    echo -e "${YELLOW}Creating plugins directory: $PLUGINS_DIR${NC}"
    mkdir -p "$PLUGINS_DIR"
fi

# 检查插件是否已存在
if [ -d "$PLUGINS_DIR/$PLUGIN_NAME" ]; then
    echo -e "${YELLOW}Plugin directory already exists: $PLUGINS_DIR/$PLUGIN_NAME${NC}"
    read -p "Do you want to overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf "$PLUGINS_DIR/$PLUGIN_NAME"
fi

# 复制插件
echo -e "${GREEN}Installing plugin to: $PLUGINS_DIR/$PLUGIN_NAME${NC}"
cp -r "$SCRIPT_DIR" "$PLUGINS_DIR/$PLUGIN_NAME"

# 检查 rootls
echo ""
echo "Checking dependencies..."
if command -v rootls &> /dev/null; then
    ROOTLS_PATH=$(which rootls)
    echo -e "${GREEN}✓ rootls found: $ROOTLS_PATH${NC}"
else
    echo -e "${RED}✗ rootls not found${NC}"
    echo ""
    echo "Please install ROOT framework:"
    echo "  macOS: brew install root"
    echo "  Linux: https://root.cern/install/"
    echo ""
fi

# 提示用户配置
echo ""
echo -e "${GREEN}Installation completed!${NC}"
echo ""
echo "Next steps:"
echo "1. Add the following to your $YAZI_CONFIG_DIR/yazi.toml:"
echo ""
echo -e "${YELLOW}   [[preview.rules]]"
echo "   name = \"*.root\""
echo "   use = \"root-preview\"${NC}"
echo ""
echo "2. Restart yazi"
echo ""
echo "For more information, see: $PLUGINS_DIR/$PLUGIN_NAME/README.md"

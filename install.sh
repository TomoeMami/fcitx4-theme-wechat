#!/bin/sh
# 安装 WeChat Light 皮肤到 fcitx4
set -e
SRC_DIR=$(cd "$(dirname "$0")" && pwd)
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/fcitx/skin/wechat"

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -r "$SRC_DIR/wechat" "$DEST"
echo "皮肤已安装到: $DEST"
echo
echo "还需要两步才能生效："
echo "  1) 在 ~/.config/fcitx/conf/fcitx-classic-ui.config 的 [ClassicUI] 段加入"
echo "       SkinType=wechat"
echo "  2) 重启 fcitx（皮肤只在启动时读取）"
echo "       fcitx-remote -e; sleep 2; fcitx -d"

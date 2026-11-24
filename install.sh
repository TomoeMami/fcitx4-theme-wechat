#!/bin/sh
# 安装 WeChat Light 皮肤到 fcitx4
#
# 用法:
#   ./install.sh            # 交互选择
#   ./install.sh 2x         # 200% 缩放（192 DPI / HiDPI）
#   ./install.sh 1x         # 100% 缩放（96 DPI）
set -e

SRC_DIR=$(cd "$(dirname "$0")" && pwd)
SKIN_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/fcitx/skin"
CONF="$HOME/.config/fcitx/conf/fcitx-classic-ui.config"

# 自动探测当前缩放，作为默认建议
DPI=$(xrdb -query 2>/dev/null | awk '/^Xft\.dpi/{print $2; exit}')
if [ -n "$DPI" ] && [ "$DPI" -ge 144 ] 2>/dev/null; then
    SUGGEST=2x
else
    SUGGEST=1x
fi

VARIANT="$1"
if [ -z "$VARIANT" ]; then
    echo "当前检测到 Xft.dpi=${DPI:-未设置}，建议使用 ${SUGGEST} 版本。"
    printf "请选择版本 [1x/2x]（直接回车 = %s）: " "$SUGGEST"
    read -r VARIANT
    [ -z "$VARIANT" ] && VARIANT="$SUGGEST"
fi

case "$VARIANT" in
    1x|2x) ;;
    *) echo "错误：版本只能是 1x 或 2x，收到 '$VARIANT'" >&2; exit 1 ;;
esac

SRC="$SRC_DIR/wechat-$VARIANT"
[ -d "$SRC" ] || { echo "错误：找不到 $SRC" >&2; exit 1; }

DEST="$SKIN_ROOT/wechat-$VARIANT"
mkdir -p "$SKIN_ROOT"
rm -rf "$DEST"
cp -r "$SRC" "$DEST"
echo "已安装: $DEST"

# 尝试自动写入 SkinType
if [ -f "$CONF" ]; then
    if grep -q '^#\?SkinType=' "$CONF"; then
        sed -i "s|^#\?SkinType=.*|SkinType=wechat-$VARIANT|" "$CONF"
    else
        printf '\n[ClassicUI]\nSkinType=wechat-%s\n' "$VARIANT" >> "$CONF"
    fi
    echo "已设置 SkinType=wechat-$VARIANT"
else
    echo "未找到 $CONF，请手动在 [ClassicUI] 段加入: SkinType=wechat-$VARIANT"
fi

echo
echo "皮肤只在 fcitx 启动时读取，需要重启进程才生效："
echo "    fcitx-remote -e; sleep 2; fcitx -d"

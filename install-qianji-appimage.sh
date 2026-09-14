#!/usr/bin/env bash
set -Eeuo pipefail

APP_ID=com.litangtech.qianji.fltlnx
DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
INSTALL_DIR="$DATA_HOME/qianji-appimage"
APPIMAGE_DEST="$INSTALL_DIR/qianji.AppImage"
PREVIOUS_DEST="$INSTALL_DIR/qianji.previous.AppImage"
APPLICATIONS_DIR="$DATA_HOME/applications"
DESKTOP_DEST="$APPLICATIONS_DIR/$APP_ID.desktop"
ICON_DIR="$DATA_HOME/icons/hicolor/512x512/apps"
ICON_DEST="$ICON_DIR/$APP_ID.png"
MANAGER_DEST="$INSTALL_DIR/manage-qianji-appimage.sh"

refresh_desktop() {
  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APPLICATIONS_DIR" >/dev/null 2>&1 || true
  fi
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -q -t -f "$DATA_HOME/icons/hicolor" >/dev/null 2>&1 || true
  fi
}

if [[ ${1:-} == --uninstall ]]; then
  rm -f -- "$APPIMAGE_DEST" "$PREVIOUS_DEST" "$DESKTOP_DEST" "$ICON_DEST" "$MANAGER_DEST"
  rmdir -- "$INSTALL_DIR" 2>/dev/null || true
  refresh_desktop
  echo '钱迹已从当前用户的应用菜单中卸载；应用数据未删除。'
  exit 0
fi

if [[ $# -gt 1 ]]; then
  echo "用法：$(basename "$0") [AppImage路径|--uninstall]" >&2
  exit 2
fi

if [[ $# == 1 ]]; then
  SOURCE=$1
else
  SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
  shopt -s nullglob
  candidates=("$SCRIPT_DIR"/qianji_*.AppImage)
  shopt -u nullglob
  if [[ ${#candidates[@]} == 0 ]]; then
    echo '未找到钱迹 AppImage。请把安装脚本与 qianji_*.AppImage 放在同一目录，或将 AppImage 路径作为参数传入。' >&2
    exit 1
  fi
  SOURCE=${candidates[0]}
  for candidate in "${candidates[@]:1}"; do
    [[ $candidate -nt $SOURCE ]] && SOURCE=$candidate
  done
fi

SOURCE=$(realpath -- "$SOURCE")
[[ -f "$SOURCE" ]] || { echo "AppImage 不存在：$SOURCE" >&2; exit 1; }
[[ -x "$SOURCE" ]] || chmod u+x "$SOURCE"

CHECKSUM_FILE="$SOURCE.sha256"
if [[ -f "$CHECKSUM_FILE" ]]; then
  (cd -- "$(dirname -- "$SOURCE")" && sha256sum -c -- "$(basename -- "$CHECKSUM_FILE")")
else
  echo '提示：未找到配套 SHA-256 文件，跳过完整性校验。' >&2
fi

TEMP_DIR=$(mktemp -d)
trap 'rm -rf -- "$TEMP_DIR"' EXIT
(cd "$TEMP_DIR" && "$SOURCE" --appimage-extract 'usr/share/icons/hicolor/512x512/apps/qianji.png' >/dev/null)
EXTRACTED_ICON="$TEMP_DIR/squashfs-root/usr/share/icons/hicolor/512x512/apps/qianji.png"
[[ -f "$EXTRACTED_ICON" ]] || { echo 'AppImage 中缺少钱迹图标，停止安装。' >&2; exit 1; }

install -d -m 0755 "$INSTALL_DIR" "$APPLICATIONS_DIR" "$ICON_DIR"
if [[ -f "$APPIMAGE_DEST" ]]; then
  cp -a -- "$APPIMAGE_DEST" "$PREVIOUS_DEST"
fi
install -m 0755 "$SOURCE" "$INSTALL_DIR/.qianji.AppImage.new"
mv -f -- "$INSTALL_DIR/.qianji.AppImage.new" "$APPIMAGE_DEST"
install -m 0755 "$(realpath -- "$0")" "$MANAGER_DEST"
install -m 0644 "$EXTRACTED_ICON" "$ICON_DEST"

cat > "$DESKTOP_DEST" <<DESKTOP
[Desktop Entry]
Type=Application
Name=QianJi
Name[zh_CN]=钱迹
Comment=Personal finance tracker
Exec="$APPIMAGE_DEST"
Icon=$ICON_DEST
Terminal=false
Categories=Office;Finance;
StartupNotify=true
StartupWMClass=$APP_ID
DESKTOP
chmod 0644 "$DESKTOP_DEST"
refresh_desktop

echo
echo '钱迹已安装到当前用户。'
echo '现在可以在应用菜单中搜索“钱迹”启动。'
echo "安装位置：$APPIMAGE_DEST"
echo "卸载命令：$MANAGER_DEST --uninstall"

# 钱迹 Linux

本仓库提供钱迹 Linux 版官方安装包与安装说明。钱迹是一款专注于个人记账与财务管理的应用，相关信息请访问[钱迹官网](https://www.qianjiapp.com/)。

> Linux 版目前处于测试发布阶段，仅提供 x86_64 架构。安装包通过本仓库的 GitHub Releases 分发。

## 下载

请从 [Releases](https://github.com/NeroSong/Qianji-Linux-Release/releases) 下载最新版本。每个版本均包含：

| 发行版 | 安装包 |
| --- | --- |
| Ubuntu / Debian | `qianji_v版本-build-commit_amd64.deb` |
| Fedora / RPM 系发行版 | `qianji_v版本-build-commit_x86_64.rpm` |
| Arch Linux / Omarchy | `qianji_v版本-build-commit_x86_64.pkg.tar.zst` |
| 其他兼容的 x86_64 桌面发行版 | `qianji_v版本-build-commit_amd64.AppImage` |

根据自身系统下载对应安装包即可。

## 校验下载

每个安装包都附带同名 `.sha256` 文件。下载后在同一目录执行：

```bash
sha256sum -c qianji_*.sha256
```

只有对应文件显示 `OK` 时才继续安装。校验失败时请重新下载，不要运行该文件。

## 安装

### Ubuntu / Debian

```bash
sudo apt install ./qianji_v版本-build-commit_amd64.deb
```

卸载：

```bash
sudo apt remove qianji
```

### Fedora / RPM 系发行版

```bash
sudo dnf install ./qianji_v版本-build-commit_x86_64.rpm
```

卸载：

```bash
sudo dnf remove qianji
```

### Arch Linux / Omarchy

```bash
sudo pacman -U ./qianji_v版本-build-commit_x86_64.pkg.tar.zst
```

卸载：

```bash
sudo pacman -Rns qianji
```

### AppImage

无需安装即可直接运行：

```bash
chmod +x qianji_v版本-build-commit_amd64.AppImage
./qianji_v版本-build-commit_amd64.AppImage
```

如需为当前用户注册应用菜单和图标，可将 Release 中的 `install-qianji-appimage.sh` 与 AppImage、对应 `.sha256` 文件放在同一目录，然后执行：

```bash
chmod +x install-qianji-appimage.sh
./install-qianji-appimage.sh ./qianji_v版本-build-commit_amd64.AppImage
```

该方式不需要 `sudo`。升级时用新 AppImage 重复执行安装器。

卸载：

```bash
~/.local/share/qianji-appimage/manage-qianji-appimage.sh --uninstall
```

## 已验证环境

- Ubuntu 22.04：DEB 构建与安装、AppImage 构建。
- Ubuntu 24.04：AppImage 用户级安装、应用菜单与图标、桌面启动和卸载。
- Fedora 44：RPM 干净安装、文件与运行时依赖检查，以及 Workstation 桌面安装。
- Arch Linux / Omarchy：原生包构建、安装、桌面运行。

其他发行版或版本可能可以运行，但在完成实际验收前不列入官方验证范围。

## 反馈与安全问题

一般问题可通过钱迹应用内的反馈功能提交，也可发送邮件至 [a@qianji.app](mailto:a@qianji.app)。Linux 版安装/使用问题也可以直接在本仓库提交 Issue。

安全问题请勿在公开 Issue 中披露，请直接邮件联系。

## 使用与分发

钱迹是专有软件。本仓库公开的是官方编译产物与辅助安装脚本，并非源代码。下载或使用前请阅读：

- [分发声明](DISTRIBUTION-NOTICE.md)
- [用户协议](https://docs.qianjiapp.com/user_agreement.html)
- [隐私政策](https://docs.qianjiapp.com/privacy_policy_android_hd.html)

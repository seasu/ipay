# AGENTS.md

## Project Overview

**ipay** — Flutter 版本的 I-Pay（支付應用程式）。使用 Flutter 框架，支援 Web 和 Linux 桌面平台。

## Cursor Cloud specific instructions

### Flutter SDK

Flutter SDK 安裝在 `/opt/flutter`，已加入 `PATH`（透過 `~/.bashrc`）。版本：Flutter 3.27.4 stable，Dart 3.6.2。

### 常用開發指令

| 動作 | 指令 |
|---|---|
| 安裝依賴 | `flutter pub get` |
| 靜態分析（lint） | `flutter analyze` |
| 執行測試 | `flutter test` |
| Web 開發伺服器 | `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0` |
| Web 建置 | `flutter build web` |
| Linux 建置 | `flutter build linux` |
| 環境檢查 | `flutter doctor` |

### 注意事項

- 此環境無 Android SDK / Android Studio，不支援 Android 建置。Web 和 Linux 桌面平台完整可用。
- Flutter web dev server 啟動後會佔住終端，適合用背景模式執行或搭配 `&` 使用。
- `flutter run -d web-server` 啟動的是 debug mode web server，支援 hot restart（按 `r`）。
- Linux 桌面建置需要 GTK3 開發函式庫（已安裝：`libgtk-3-dev`、`clang`、`cmake`、`ninja-build`、`pkg-config`）。

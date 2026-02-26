# I-Pay

Flutter 版本的 I-Pay — 一個類似「終極密碼」的猜數字遊戲。

## 遊戲規則

1. 系統隨機產生一個 1～100 的秘密數字
2. 玩家在目前的範圍內猜一個數字
3. 如果猜的數字太大，上界會縮小；太小則下界會放大
4. 猜中秘密數字的玩家「踩到地雷」，遊戲結束！

## 開發

```bash
flutter pub get        # 安裝依賴
flutter analyze        # 靜態分析
flutter test           # 執行測試
flutter run -d chrome  # 在 Chrome 中執行
```

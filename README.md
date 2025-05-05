# calendar-flutter-test

パッケージ [table_calendar](https://pub.dev/packages/table_calendar) の利用とカスタマイズ例

<br>

### カスタマイズした点

- 年・月のドロップダウンを設置し、表示年月を兼ねた

- 現在月に戻るボタンを追加
- 曜日と日の各セルに罫線を追加、どの線も1本にして線幅を揃えた
- サンプルデータ (JSON) を読み込み、日毎の予定件数を表示
- 現在日と選択日 (クリックした日) を別々の背景色でハイライト

<br>

### 対象プラットフォーム

- macos

- web (Chrome)
- iOS
- Android

<br>

### スクリーンショット

- Chrome

  <img width="512" alt="chrome" src="https://github.com/user-attachments/assets/cc781776-e6d7-44af-ada3-bcdbddf96655" />

<br>

- Android Emulator (Medium Tablet, Android 16.0)

  <img width="512" alt="android" src="https://github.com/user-attachments/assets/7be3cc35-f7b0-4d42-9c17-58ec3c08e322" />

<br>

- macos

  <img width="512" alt="macos" src="https://github.com/user-attachments/assets/e4c677b1-d3b2-4d83-b583-126bc3d8bf11" />

<br>

- iOS Simulator (iPad 10th, iPadOS 18.3)

  <img width="512" alt="iOS" src="https://github.com/user-attachments/assets/67476b9a-b1a5-4421-9792-b00d1b5a7c12" />

<br>

### 参考にしたもの

- https://github.com/shin-yamamoto/custom_table_calendar

- https://qiita.com/yamashinsan/items/a618460ce53161a63d4d

<br>

### TODOなど

- Chromeのみ、絵文字がおかしい🤔

- カレンダーの上余白がAndroidとiPhoneで反映されず、画面上端に近すぎ🤔

- 罫線の重複を避ける処理が複雑なので、バグがあるかも😅

<br>

### 動作確認環境
```
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[!][!] Flutter (Channel [user-branch], 3.24.5, on macOS 15.4.1 24E263 darwin-x64,
    locale en-JP)
    ! Flutter version 3.24.5 on channel [user-branch] at
      /usr/local/Caskroom/flutter/3.29.2/flutter
      Currently on an unknown channel. Run `flutter channel` to switch to an
      official channel.
      If that doesn't fix the issue, reinstall Flutter by following instructions
      at https://flutter.dev/setup.
    ! Upstream repository unknown source is not a standard remote.
      Set environment variable "FLUTTER_GIT_URL" to unknown source to dismiss
      this error.
[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.3)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.3)
[✓] VS Code (version 1.99.3)
```

```
$ flutter devices
  sdk gphone64 x86 64 (mobile)    ...  • Android 16 (API 36) (emulator)
  macOS (desktop)                 ...  • macOS 15.4.1 24E263 darwin-x64
  Chrome (web)                    ...  • Google Chrome 135.0.7049.115
  iPad (10th generation) (mobile) ...  • com.apple.CoreSimulator.SimRuntime.iOS-18-3 (simulator)
```

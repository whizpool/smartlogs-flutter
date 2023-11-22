<h1 align="center">Smart Log</h1>

<p align="center">Introducing a sleek Flutter package designed to streamline user event logging and exception reporting. With this package, users can easily submit bug reports to developers via a user-friendly dialog. Developers can specify their email address, simplifying the process of receiving vital bug reports.

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <!-- <a href="packLink">
    <img src="https://img.shields.io/pub/v"
      alt="Pub Package" />
  </a> -->

</p>

# Table of contents

- [Installing](#installing)
  - [Android](#installing)
- [Usage](#usage)
  [Smart log report dialog](#smart-log-report-dialog)
  - [Dialog](#dialog)
  - [SLog Report Dialog All Parameters](#slog-report-dialog-all-parameters)
- [Bugs or Requests](#bugs-or-requests)

# Installing

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_logs: ^0.0.5
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```
$ pub get
```

with `Flutter`:

```
$ flutter pub get
```

### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:smart_logs/smart_logs.dart';
```

## Android Setup

With Android 11, package visibility is introduced that alters the ability to query installed applications and packages on a user’s device. To enable your application to get visibility into the packages you will need to add a list of queries into your AndroidManifest.xml.
**Note** To utilize the report dialog with default report button settings on Android, you are required to perform some configuration steps. Here are the necessary instructions:

```
<manifest package="com.mycompany.myapp">
  <queries>
    <intent>
      <action android:name="android.intent.action.SENDTO" />
      <data android:scheme="mailto" />
    </intent>
  </queries>
</manifest>
```

# Usage

`Smart Log` This package offers a range of methods for various functionalities. However, to ensure smooth operation, it's crucial to initialize it first. You can initialize it from anywhere in your app, but it's advisable to call the initialize method in the `main` function for optimal performance. like:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Slog.initializeSLog();
  // Your Code
}
```

It has many configurable properties `(Optional)`, including:

- `forceFullyDelete` – to delete everything related to logs. like zip, json and .log files
- `daysToDeleteLog` – To remove logs created before a specified date, this parameter is set to delete logs older than 7 days by default.
- `logFolderName` – to designate the name of your log file folder or directory...
- `logZipFileName` – to designate the name of your log zip file.
- `jsonFileName` – to designate the name of your json file.

There are also custom setter's, getter's, callbacks:

- `setForceFullyDelete(bool value)` – When set to true, this setter will forcibly delete all data related to logs.
- `setZipPassword(String value)` – This setter method allows you to add a password to zip file created.
- `getLogFileAsText` – This getter returns the current log file content as a string.
- `addLog(String message, {Exception? exception})` – This method adds your log message to the log file. The exception parameter is optional and can be used to include an exception in the log message.
- `getLogAsZip()` - This callback creates a zip file of the log files and returns the path to the zip file.

**Note:**
You might encounter a `NotInitializationException` if you call an `instance` of SLog directly. When the initialize method is called, it takes some time for initialization. It is recommended to `await` the initialization method to ensure that the necessary setup is completed before using SLog `instances`.

<!-- ## First version

Version 3 refactored the code so that common animation controls were moved to
`AnimatedTextKit` and all animations, except for `TextLiquidFill`, extend from
`AnimatedText`. This saved hundreds of lines of duplicate code, increased
consistency across animations, and makes it easier to create new animations.

It also makes the animations more flexible because multiple animations may now
be easily combined. For example: -->

```dart
// Adding log
Slog.instance.addLog('your message');
// Log with exception
Slog.instance.addLog('your message', exception:YourException());
```

```dart
// Getting File content as String
Slog.instance.getLogFileAsText;
// Log with exception
Slog.instance.addLog('your message', exception:YourException());
```

### Smart log report dialog

Smart Report Dialog is a part of Smart log Flutter package that streamlines the process of collecting user bug reports. Users can enter their bug report messages, and when they tap the send button, they are redirected to their email app with a pre-configured email. The email includes two default attachments: a zipped log file and a deviceinfo.json file containing device information. This dialog is highly customizable, allowing you to modify the title, hintText, buttonTitle, buttonStyle, and the dialog's background. You can also customize the send button callback to provide your own functionality. This package simplifies the bug reporting process, enhancing the user experience.

## Dialog

<img src="https://github.com/ahmad-whizpool/example_package/assets/143999277/44ce9750-be15-45a3-975a-ab51040d3540" align = "right" height = "300px">

```dart
 SLogReportDialog.S_LOG_REPORT_DIALOG(
    context,
    sendToEmail: 'example@gmail.com',
    emailsubject: 'Example Bug by user',
    );
```

**Note:** These 3 parameter is required. In which one is positional and two are optional parameter

# SLog Report Dialog All Parameters

```dart
S_LOG_REPORT_DIALOG(
    BuildContext context, {
    required String emailsubject,
    required String sendToEmail,
    bool dialogBarrierDismissible = false,
    ButtonStyle? sendButtonStyle,
    BoxDecoration? topContainerDecoration,
    Color dialogBackgroundColor = Colors.white,
    Color? reportbodyBackgrounColor,
    Color dialogBarrierColor = Colors.black38,
    Color? dividerColor,
    Color toastBackGround = Colors.black,
    Color toastTextColor = Colors.white,
    double dialogElevation = 0,
    double dialogWithOpacity = .5,
    double toastFontSize = 15,
    EdgeInsetsGeometry? dialogWidgetsPadding,
    Function()? reportButtonPress,
    IconData buttonIcon = CupertinoIcons.paperplane_fill,
    int minmumBodyLength = 10,
    String hintText = 'Write here about your bug detail',
    String? minmumToastText,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
    List<String>? sendToEmails,
    List<String>? cc,
    List<String>? bcc,
    TextStyle? bodyTextStyle,
    TextStyle? hintTextStyle,
    Widget? buttonTitle,
    Widget? divider,
    Widget? reportTitle,
  })
```

# Bugs or Requests

If you encounter any problems feel free to open an [issue](https://github.com/whizpool/smartlogs-flutter/issues/new?template=bug_report.md). If you feel the library is missing a feature, please raise a [ticket](https://github.com/whizpool/smartlogs-flutter/issues/new?template=feature_request.md) on GitHub and I'll look into it. Pull request are also welcome.

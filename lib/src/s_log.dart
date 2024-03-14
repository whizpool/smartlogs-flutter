part of '../smart_logs.dart';

class Slog {
  /// Private variables which can be used by Slog only
  static Slog? _instance;
  static const String _completeDateformat = 'dd-MM-yyyy hh:mm:ss a';
  static const String _dateformat = 'dd-MM-yyyy';
  static String _logFolderName = 'Logs';
  static String _logZipFileName = 'logs.zip';
  static String _jsonFileName = 'deviceInfo.json';
  static String _zipFolderName = 'New Zip';
  static String? _logFileName;
  static String? _zipPassword;
  static late bool _forceFullyDelete;
  static late int _daysToDeleteLog;
  static Directory? _logDirectory;

  /// Making Constructor private so it can't be instantiate from outside of this file
  Slog._();

  /// Getters
  /// Get Instance of Slog of not initialize it will through Not Initialize Exception
  static Slog get instance {
    if (_instance == null) {
      throw NotInitializationException();
    } else {
      return _instance!;
    }
  }

  ///to get current day log file as String
  Future<String> get getLogFileAsText async {
    final file = await _getLogFile();
    return file.readAsStringSync();
  }

  /// Setters
  /// to set ForceFullyDelete that delete all logs and zips files and folders
  set setForceFullyDelete(bool value) {
    _forceFullyDelete = value;
    _deleteLogFile();
  }

  /// to set days before which logs will be deleted
  set setDaysToDeleteLog(int value) {
    _daysToDeleteLog = value;
    _deleteLogFile();
  }

  /// setting password to protect log zip file
  set setZipPassword(String value) => _zipPassword = value;

  /// Method to initialize Slog
  static Future<void> initializeSLog({
    bool forceFullyDelete = false,
    int daysToDeleteLog = 7,
    String logFolderName = 'Logs',
    String logZipFileName = 'logs.zip',
    String zipFolderName = 'New Zip',
    String jsonFileName = 'deviceInfo.json',
  }) async {
    if (_instance == null) {
      _forceFullyDelete = forceFullyDelete;
      _daysToDeleteLog = daysToDeleteLog;
      _logFolderName = logFolderName;
      _logZipFileName = logZipFileName;
      _jsonFileName = jsonFileName;
      _zipFolderName = zipFolderName;
      _logDirectory = await _getDirectory();
      _logFileName = _getLogFileName();

      /// Checking for zip fiel if exist delete it
      final zipDirectory =
          Directory('${_logDirectory!.parent.path}/$_zipFolderName');

      if (zipDirectory.existsSync()) {
        zipDirectory.deleteSync(recursive: true);
      }

      /// initializing instance
      _instance = Slog._();
      if (_logDirectory != null) {
        bool fileExist =
            File('${_logDirectory!.path}/$_logFileName').existsSync();
        if (!_logDirectory!.existsSync()) {
          _logDirectory!.createSync();
        }
        if (!fileExist) {
          await _oneTimeWriteInLog();
        }
      }
      _deleteLogFile();
    }
  }

  /// method to get directory where logs file should be stored
  static Future<Directory> _getDirectory() async {
    Directory? directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    directory ??= await getApplicationDocumentsDirectory();

    return Directory('${directory.path}/$_logFolderName');
  }

  /// Methdos to get log file name. It will return file name as current formatedDate.log
  static String _getLogFileName() {
    ///get current date with proper format
    var now = DateTime.now();
    var formatter = DateFormat(_dateformat);
    String formattedDate = formatter.format(now);

    if (kDebugMode) {
      print(formattedDate);
    }

    return "$formattedDate.log";
  }

  /// When ever file get's created this method should need to be call to add head Text,
  static Future<void> _oneTimeWriteInLog() async {
    File file = await _getLogFile(true);
    final headText = await _getHeadTextOfLogFile();
    file.writeAsString(headText);
  }

  /// Method to get Log file first it will check for directory then for file after that it will return a log file.
  static Future<File> _getLogFile([bool callFromOneTimeMethod = false]) async {
    if (!await _logDirectory!.exists()) {
      await _logDirectory!.create();
    }
    File filePath = File("${_logDirectory?.path}/$_logFileName");
    if (!await filePath.exists()) {
      await filePath.create();
      if (!callFromOneTimeMethod) {
        await _oneTimeWriteInLog();
      }
    }
    return filePath;
  }

  /// Delete log file based on provided days or Force fully delete all logs
  static Future<void> _deleteLogFile() async {
    if (_logDirectory!.existsSync()) {
      final files = _logDirectory?.listSync();
      final formatedDate = DateFormat('dd-MM-yyyy');

      if ((files != null && files.length > _daysToDeleteLog)) {
        /// For loop to go through on all files
        for (var file in files) {
          final filePath = file.uri.pathSegments.last;
          final fileName = filePath.split('.').first;
          if (fileName != 'deviceInfo') {
            final differenceInDays =
                DateTime.now().difference(formatedDate.parse(fileName)).inDays;
            if (differenceInDays >= _daysToDeleteLog) {
              file.deleteSync(recursive: true);
            }
          }
        }
      } else if (_forceFullyDelete) {
        _logDirectory!.deleteSync(recursive: true);
      }
    }
  }

  /// Methed to add log into log file
  Future<void> summaryLog({
    String tag = "Message",
    required String text,
    bool shouldSave = true,
    dynamic exception,
    dynamic stackTrace,
  }) async {
    if (kDebugMode) {
      print(
          'Writing message: $text, Exception: $exception StackTrace: $stackTrace');
    }
    if (!shouldSave) return;
    final file = await _getLogFile();
    // final contents = file.readAsStringSync();

    /// formating data for adding before log
    var now = DateTime.now();
    var formatter = DateFormat(_completeDateformat);
    String formattedDate = formatter.format(now);

    String newMessage =
        "$formattedDate: $tag : $text\n${exception != null ? "Exception -> $exception" : ""}\n${stackTrace != null ? "StackTrace -> $stackTrace" : ""}\n";

    /// Writing the log into log file
    file.writeAsStringSync(newMessage, mode: FileMode.append);
  }

  /// Method to return Head of Log file which contains information about Device and App
  static Future<String> _getHeadTextOfLogFile() async {
    final headLine =
        '******************************* $_logFileName *******************************\n';
    String headText = headLine;

    final information = await _getInformationofAppAndDevice();

    /// Convertring map into define formate string
    String infromateText = '';
    information.forEach((key, value) {
      infromateText += '$key: $value\n';
    });

    headText = '$headText$infromateText';
    headText = '$headText${headLine.replaceAll(RegExp(r'.'), '*')}\n';

    return headText;
  }

  /// method to return information of device and app in a map object.
  static Future<Map<String, dynamic>> _getInformationofAppAndDevice() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? osInstalled;
    String? manufacture;
    String? deviceModel;

    /// Information about APP

    /// Infromation about currently running OS whether it is iOS or Android
    if (Platform.isIOS) {
      /// Informaion about iOS
      final iosInfo = await deviceInfo.iosInfo;
      osInstalled = iosInfo.systemVersion;
      deviceModel = '${iosInfo.utsname.machine} (${iosInfo.utsname.nodename})';
    } else if (Platform.isAndroid) {
      /// Information about Android
      final androidInfo = await deviceInfo.androidInfo;
      osInstalled = androidInfo.version.release;
      deviceModel = '${androidInfo.product} ${androidInfo.model}';
      manufacture = androidInfo.manufacturer;
    }

    /// Infromation about free available space
    double diskSpace = await DiskSpaceUpgrade.getFreeDiskSpace ?? 0;
    final freeSpaceInGB = (diskSpace / 1000).toStringAsFixed(2);

    return {
      'appVersion': packageInfo.version,
      'appName': packageInfo.appName,
      'freeSpace': '$freeSpaceInGB GB',
      'OSInstalled': osInstalled,
      'manufacture': manufacture ?? "iPhone",
      'deviceModel': deviceModel,
    };
  }

  /// Method to convert log file into zip. base on user need whether they want a protected zip or not
  Future<String> getLogAsZip() async {
    final zipEncoder = ZipFileEncoder(password: _zipPassword);

    /// Create and store zip file if logDirectory is not null
    if (_logDirectory != null) {
      final zipPath =
          '${_logDirectory!.parent.path}/$_zipFolderName/$_logZipFileName';
      zipEncoder.create(zipPath);
      zipEncoder.addDirectory(_logDirectory!);
      zipEncoder.close();
    }
    return zipEncoder.zipPath;
  }

  /// Method to create json file which contain only device and app information
  Future<String> getJsonFile() async {
    final zipDirectory =
        Directory('${_logDirectory!.parent.path}/$_zipFolderName');

    /// checking if zip directory not exists create one
    if (!await zipDirectory.exists()) {
      await zipDirectory.create();
    }
    final jsonFile = File('${zipDirectory.path}/$_jsonFileName');

    if (!await jsonFile.exists()) {
      await jsonFile.create();
    }
    final informationMap = await _getInformationofAppAndDevice();

    /// convert information map into json define formate
    List<String> keyValuePairs = informationMap.entries
        .map((entry) => '"${entry.key}": "${entry.value}"')
        .toList();
    String formattedJson = keyValuePairs.join(',\n');

    /// Add brackets for proper JSON format
    formattedJson = '{\n$formattedJson\n}';

    jsonFile.writeAsString(formattedJson);
    return jsonFile.path;
  }

  /// Method to send ZipFile as email
  Future<void> sendReport({
    required String body,
    required String subject,
    List<String>? sendToEmails,
    required String sendToEmail,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    try {
      /// Getting zipFile and JsonFile path's
      final getZipFile = await Slog.instance.getLogAsZip();
      final getJsonFile = await Slog.instance.getJsonFile();

      /// Preparing Email
      final Email email = Email(
        body: body,
        subject: subject,
        recipients: [sendToEmail, ...sendToEmails ?? []],
        cc: cc ?? [],
        bcc: bcc ?? [],
        attachmentPaths: [getZipFile, getJsonFile],
        isHTML: false,
      );

      /// Sending email
      await FlutterEmailSender.send(email);

      // Delete zip after sending email
      // await Directory(File(getZipFile).parent.path).delete(recursive: true);

      // Delete json file after sending email
      // await File(getJsonFile).delete(recursive: true);
    } on PlatformException catch (e) {
      Slog.instance.summaryLog(text: 'Exception while sending email is: $e');
      Fluttertoast.showToast(
          msg: "can't send mail, please configure your email");
    } catch (e) {
      Slog.instance.summaryLog(text: 'Exception while sending email is: $e');
    }
  }
}

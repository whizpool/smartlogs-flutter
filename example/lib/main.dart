import 'package:smart_logs/smart_logs.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Slog.initializeSLog();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Smart log Demo',
      // theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: SendBugReport(),
    );
  }
}

class SendBugReport extends StatefulWidget {
  const SendBugReport({
    super.key,
  });

  @override
  State<SendBugReport> createState() => _SendBugReportState();
}

class _SendBugReportState extends State<SendBugReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Smart Log"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Slog.instance.summaryLog(
                    text: 'User Press add log button',
                    // shouldSave: false,
                  );
                },
                child: const Text(
                  "Add Log",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    throw const FormatException();
                  } on FormatException catch (e, stackTrace) {
                    Slog.instance.summaryLog(
                      text: 'User Press add log button',
                      exception: e,
                      stackTrace: stackTrace,
                      // shouldSave: false,
                    );
                  }
                },
                child: const Text(
                  "Add Log with exception",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Slog.instance.summaryLog(
                    text: 'User Press Report button',
                    shouldSave: false,
                  );

                  SLDialog.SL_DIALOG(
                    context,
                    sendToEmail: 'example@gmail.com',
                    emailsubject: 'Example Bug by user',
                    topHandlerColor: Colors.black.withOpacity(.7),
                    attachmentsPaths: [],
                  );
                },
                child: const Text(
                  "Report a bug",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Slog.instance.setForceFullyDelete = true;
                },
                child: const Text(
                  "Remove Logs",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

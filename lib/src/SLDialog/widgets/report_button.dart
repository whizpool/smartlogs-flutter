// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
part of '../../../smart_logs.dart';

/// This is button widget which can prefrom sending email to developer account
class ReportButton extends StatefulWidget {
  const ReportButton({
    super.key,
    required this.emailBodyTextController,
    required this.reportButtonIcon,
    required this.reportButtonPress,
    required this.minmumEmailBodyLength,
    required this.toastBackGround,
    required this.toastTextColor,
    required this.toastFontSize,
    required this.emailsubject,
    required this.sendToEmail,
    required this.sendToEmails,
    required this.reportButtonStyle,
    required this.reportButtonTitle,
    required this.cc,
    required this.bcc,
    required this.attachmentsPaths,
    this.reportButtonLoadingWidget,
  });

  /// Button parameter which can be adjustable by any user
  final TextEditingController emailBodyTextController;
  final Widget? reportButtonIcon;
  final Function()? reportButtonPress;
  final int minmumEmailBodyLength;
  final Color toastBackGround;
  final Color toastTextColor;
  final double toastFontSize;
  final String emailsubject;
  final String sendToEmail;
  final List<String>? sendToEmails;
  final ButtonStyle? reportButtonStyle;
  final Widget? reportButtonTitle;
  final Widget? reportButtonLoadingWidget;
  final List<String>? cc;
  final List<String>? bcc;
  final List<String>? attachmentsPaths;

  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  bool isButtonPress = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton.icon(
          icon: isButtonPress
              ? null
              : widget.reportButtonIcon ??
                  const Icon(
                    CupertinoIcons.paperplane_fill,
                    size: 20,
                  ),
          onPressed: widget.reportButtonPress ??
              () async {
                /// It will show toast if app user enter email body less then developer defiend length
                if (widget.emailBodyTextController.text.length <
                    widget.minmumEmailBodyLength) {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg:
                        'Message length should be minimum ${widget.minmumEmailBodyLength}',
                    gravity: Platform.isIOS
                        ? ToastGravity.CENTER
                        : ToastGravity.BOTTOM,
                    backgroundColor: widget.toastBackGround,
                    textColor: widget.toastTextColor,
                    fontSize: widget.toastFontSize,
                  );
                } else {
                  setState(() {
                    isButtonPress = true;
                  });
                  try {
                    await Slog.instance.sendReport(
                      body: widget.emailBodyTextController.text,
                      subject: widget.emailsubject,
                      sendToEmail: widget.sendToEmail,
                      sendToEmails: widget.sendToEmails,
                      cc: widget.cc,
                      bcc: widget.bcc,
                      attachmentsPaths: widget.attachmentsPaths,
                    );
                  } finally {
                    isButtonPress = false;
                    Navigator.of(context).pop();
                  }
                }
              },
          style: widget.reportButtonStyle ??
              ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(
                  double.infinity,
                  45,
                ),
              ),
          label: isButtonPress
              ? SizedBox()
              : widget.reportButtonTitle ??
                  const Text(
                    "Send Report",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
        ),
        if (isButtonPress)
          Positioned.fill(
            child: widget.reportButtonLoadingWidget ??
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
          )
      ],
    );
  }
}

part of smart_logs;

class ReportButton extends StatelessWidget {
  const ReportButton(
      {super.key,
      required this.reportController,
      required this.buttonIcon,
      required this.buttonTitle,
      required this.emailsubject,
      required this.minmumBodyLength,
      required this.reportButtonPress,
      required this.sendButtonStyle,
      required this.sendToEmail,
      required this.sendToEmails,
      required this.toastBackGround,
      required this.toastFontSize,
      required this.toastTextColor,
      required this.cc,
      required this.bcc});

  final TextEditingController reportController;
  final IconData buttonIcon;
  final Function()? reportButtonPress;
  final int minmumBodyLength;
  final Color toastBackGround;
  final Color toastTextColor;
  final double toastFontSize;
  final String emailsubject;
  final String sendToEmail;
  final List<String>? sendToEmails;
  final ButtonStyle? sendButtonStyle;
  final Widget? buttonTitle;
  final List<String>? cc;
  final List<String>? bcc;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        buttonIcon,
        size: 20,
      ),
      onPressed: reportButtonPress ??
          () async {
            if (reportController.text.length < 10) {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: 'Message length should be minimum $minmumBodyLength',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: toastBackGround,
                textColor: toastTextColor,
                fontSize: toastFontSize,
              );
            } else {
              Slog.instance.sendReport(
                body: reportController.text,
                subject: emailsubject,
                sendToEmail: sendToEmail,
                sendToEmails: sendToEmails,
                cc: cc,
                bcc: bcc,
              );
              Navigator.of(context).pop();
            }
          },
      style: sendButtonStyle ??
          ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size(
              double.infinity,
              45,
            ),
          ),
      label: buttonTitle ??
          const Text(
            "Send Report",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
    );
  }
}

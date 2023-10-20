part of smart_logs;

/// This is button widget which can prefrom sending email to developer account
class ReportButton extends StatelessWidget {
  const ReportButton({
    super.key,
    required this.emailBodyTextController,
    required this.reportButtonIcon,
    required this.reportButtonTitle,
    required this.emailsubject,
    required this.minmumEmailBodyLength,
    required this.reportButtonPress,
    required this.reportButtonStyle,
    required this.sendToEmail,
    required this.sendToEmails,
    required this.toastBackGround,
    required this.toastFontSize,
    required this.toastTextColor,
    required this.cc,
    required this.bcc,
  });

  /// Button parameter which can be adjustable by any user
  final TextEditingController emailBodyTextController;
  final IconData reportButtonIcon;
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
  final List<String>? cc;
  final List<String>? bcc;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        reportButtonIcon,
        size: 20,
      ),
      onPressed: reportButtonPress ??
          () async {
            /// It will show toast if app user enter email body less then developer defiend length
            if (emailBodyTextController.text.length < minmumEmailBodyLength) {
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: 'Message length should be minimum $minmumEmailBodyLength',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: toastBackGround,
                textColor: toastTextColor,
                fontSize: toastFontSize,
              );
            } else {
              Slog.instance.sendReport(
                body: emailBodyTextController.text,
                subject: emailsubject,
                sendToEmail: sendToEmail,
                sendToEmails: sendToEmails,
                cc: cc,
                bcc: bcc,
              );
              Navigator.of(context).pop();
            }
          },
      style: reportButtonStyle ??
          ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size(
              double.infinity,
              45,
            ),
          ),
      label: reportButtonTitle ??
          const Text(
            "Send Report",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
    );
  }
}

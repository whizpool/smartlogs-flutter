part of smart_logs;

class SLDialog {
  // ignore: non_constant_identifier_names
  static SL_DIALOG(
    BuildContext context, {
    bool dialogBarrierDismissible = false,
    ButtonStyle? sendButtonStyle,
    BoxDecoration? topContainerDecoration,
    Color? dialogBackgroundColor,
    Color? reportbodyBackgrounColor,
    Color dialogBarrierColor = Colors.black38,
    Color? lineColor,
    Color toastBackGround = Colors.black,
    Color toastTextColor = Colors.white,
    double dialogElevation = 0,
    double dialogWithOpacity = .5,
    double toastFontSize = 15,
    EdgeInsetsGeometry? dialogWidgetsPadding,
    Function()? reportButtonPress,
    IconData buttonIcon = CupertinoIcons.paperplane_fill,
    int minmumBodyLength = 10,
    int maxTextLength = 4000,
    String hintText = 'Write here about your bug detail',
    String? minmumToastText,
    required String emailsubject,
    required String sendToEmail,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
    List<String>? sendToEmails,
    List<String>? cc,
    List<String>? bcc,
    TextStyle? bodyTextStyle,
    TextStyle? hintTextStyle,
    Widget? buttonTitle,
    Widget? divider,
    Widget? reportTitle,
  }) {
    final reportController = TextEditingController();
    showModalBottomSheet(
      context: context,
      barrierColor: dialogBarrierColor,
      // barrierColor: dialogBarrierColor,
      // barrierDismissible: dialogBarrierDismissible,
      backgroundColor:
          dialogBackgroundColor ?? const Color.fromARGB(255, 222, 222, 222),
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,

      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          reportTitle ??
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Report a bug",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
          Divider(
            height: 1,
            color: lineColor ?? Colors.black.withOpacity(.8),
          ),
          Padding(
            padding: const EdgeInsets.all(
              15,
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: reportController,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: reportbodyBackgrounColor ?? Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: hintText,
                    hintStyle: hintTextStyle,
                  ),
                  maxLines: 11,
                  maxLength: maxTextLength,
                ),
                const SizedBox(
                  height: 10,
                ),
                ReportButton(
                  reportController: reportController,
                  buttonIcon: buttonIcon,
                  buttonTitle: buttonTitle,
                  bcc: bcc,
                  cc: cc,
                  emailsubject: emailsubject,
                  minmumBodyLength: minmumBodyLength,
                  reportButtonPress: reportButtonPress,
                  sendButtonStyle: sendButtonStyle,
                  sendToEmail: sendToEmail,
                  sendToEmails: sendToEmails,
                  toastBackGround: toastBackGround,
                  toastFontSize: toastFontSize,
                  toastTextColor: toastTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

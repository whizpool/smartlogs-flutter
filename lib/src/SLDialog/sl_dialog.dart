// ignore_for_file: non_constant_identifier_names

part of '../../smart_logs.dart';

// Use to show SL bottomsheet
class SLDialog {
  static SL_DIALOG(
    BuildContext context, {
    bool dialogBarrierDismissible = false,
    ButtonStyle? reportButtonStyle,
    BoxDecoration? topContainerDecoration,
    Color? dialogBackgroundColor,
    Color? emailBodyTextFieldBackgrounColor,
    Color dialogBarrierColor = Colors.black38,
    Color? lineColor,
    Color? cursorColor,
    Color toastBackGround = Colors.black,
    Color toastTextColor = Colors.white,
    double dialogElevation = 0,
    double dialogWithOpacity = .5,
    double toastFontSize = 15,
    EdgeInsetsGeometry? dialogWidgetsPadding,
    Function()? reportButtonPress,
    Widget? reportButtonIcon,
    int maxEmailBodyTextFieldLines = 10,
    int maxEmailBodyCharacterLength = 4000,
    int minimumEmailBodyLength = 10,
    String hintText = 'Write here about your bug detail',
    String? minmumToastText,
    required String emailsubject,
    required String sendToEmail,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
    List<String>? sendToEmails,
    List<String>? cc,
    List<String>? bcc,
    TextStyle? emailBodyTextStyle,
    TextStyle? hintTextStyle,
    Widget? reportButtonTitle,
    Widget? divider,
    Widget? reportTitle,
    TextStyle? textFieldTextStyle,
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
                  cursorColor: cursorColor,
                  style: textFieldTextStyle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: emailBodyTextFieldBackgrounColor ?? Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: hintText,
                    hintStyle: hintTextStyle,
                  ),
                  maxLines: maxEmailBodyTextFieldLines,
                  maxLength: maxEmailBodyCharacterLength,
                ),
                const SizedBox(
                  height: 10,
                ),
                ReportButton(
                  emailBodyTextController: reportController,
                  reportButtonIcon: reportButtonIcon,
                  reportButtonTitle: reportButtonTitle,
                  bcc: bcc,
                  cc: cc,
                  emailsubject: emailsubject,
                  minmumEmailBodyLength: minimumEmailBodyLength,
                  reportButtonPress: reportButtonPress,
                  reportButtonStyle: reportButtonStyle,
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

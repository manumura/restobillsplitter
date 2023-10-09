import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:restobillsplitter/models/alert_type.dart';

class UiHelper {
  UiHelper._();

  static void showAlertDialog(
      BuildContext context, AlertType alertType, String title, String content) {
    return _showAlertDialog(context, alertType, title, content);
  }

  static void showAlertDialogNoTitle(
      BuildContext context, AlertType alertType, String content) {
    return _showAlertDialog(context, alertType, null, content);
  }

  static void _showAlertDialog(BuildContext context, AlertType alertType,
      String? title, String content) {
    String header;
    Color btnColor;
    DialogType dialogType;
    switch (alertType) {
      case AlertType.warning:
        header = 'Warning';
        btnColor = Colors.orange;
        dialogType = DialogType.warning;
        break;
      case AlertType.error:
        header = 'Error';
        btnColor = Colors.red;
        dialogType = DialogType.error;
        break;
      case AlertType.info:
      default:
        header = 'Info';
        btnColor = Colors.blue;
        dialogType = DialogType.info;
        break;
    }

    AwesomeDialog(
            context: context,
            dialogType: dialogType,
            animType: AnimType.bottomSlide,
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (title != null)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                Text(
                  content,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            btnOkColor: btnColor,
            btnOkOnPress: () {})
        .show();
  }
}

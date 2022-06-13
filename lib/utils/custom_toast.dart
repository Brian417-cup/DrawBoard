import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';

class DrawBoardToast {
  static showCustomToast(
      BuildContext context, String titleTxt, String descriptionTxt) {
    FToast.toast(context,
        duration: 800,
        msg: titleTxt,
        subMsg: descriptionTxt,
        msgStyle: TextStyle(color: Colors.white));
  }

  static showSuccessToast(BuildContext context, String descriptionTxt) {
    FToast.toast(context,
        duration: 800,
        msg: descriptionTxt,
        msgStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        color: Colors.lightGreenAccent,
        image: Icon(
          Icons.star,
          size: 35,
          color: Colors.green,
        ));
  }

  static showErrorToast(BuildContext context, String descriptionTxt) {
    FToast.toast(context,
        duration: 800,
        msg: descriptionTxt,
        msgStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        color: Colors.red.withAlpha(100),
        image: Icon(
          Icons.wrong_location,
          size: 35,
          color: Colors.red,
        ));
  }
}

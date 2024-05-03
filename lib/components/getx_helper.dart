
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXHelper {
  static showSnackBar({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.white,
        message: message,
        messageText: Text(message,style: TextStyle(color: Colors.black),),
      )
    );
  }
}
// ignore_for_file: unnecessary_null_comparison

import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationsService2 {
static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.oscureColorb,
        content: Text(
          content,
          style: const TextStyle(color: AppColors.text, fontFamily: "MonB"),
        )));
  }
}

void showSnackbar2(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
      backgroundColor: AppColors.oscureColorb,
      content: Text(
        content,
        style: const TextStyle(color: AppColors.text, fontFamily: "MonB"),
      )));
}


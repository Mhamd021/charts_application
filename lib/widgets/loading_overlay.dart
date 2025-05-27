import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static void show() => Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
  
  static void hide() => Get.back();
}

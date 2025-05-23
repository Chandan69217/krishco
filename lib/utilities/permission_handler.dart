import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{
  PermissionHandler._();

  static Future<bool> handleCameraPermission(BuildContext context) async {

    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted){
      return true;
    } else {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        return true;
      } else if (newStatus.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('Camera permission denied'))));
        return false;
      } else if (newStatus.isPermanentlyDenied) {
        openAppSettings();
        return false;
      }
      return false;
    }
  }
}
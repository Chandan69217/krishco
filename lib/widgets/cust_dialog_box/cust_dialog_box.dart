import 'package:flutter/material.dart';



class CustDialog {
  static Future<void> show({
    required BuildContext context,
    String title = 'Notice',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              if (onConfirm != null) onConfirm(); // Optional callback
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

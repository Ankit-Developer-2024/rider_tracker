import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

String getLocalImage(String name) {
  return 'assets/image/$name.png';
}

String getLocalSvg(String name) {
  return 'assets/svg/$name.svg';
}

String getLocalPng(String name) {
  return 'assets/png/$name.png';
}

String getLocalGif(String name) {
  return 'assets/gif/$name.gif';
}

String getLocalJPG(String name) {
  return 'assets/jpg/$name.jpg';
}

void appLog(dynamic text) {
   if (kDebugMode) debugPrint(text?.toString());
}


void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}


bool isUrlCorrect(String? imagePath) {
  if (imagePath != null && imagePath.isNotEmpty) {
    bool validURL = Uri.parse(imagePath).isAbsolute;
    return validURL;
  }
  return false;
}


String truncateTo2digitAfterDecimal(String value) {
  double n = double.parse(value);
  double truncated = (n * 100).floor() / 100;
  return truncated.toString();
}

String changeToHourIfNeeded(int value) {
  if (value==0) return "";
  if(value<=60) return "${value.toString()} min";
  return "${truncateTo2digitAfterDecimal((double.tryParse(value.toString())!/60).toDouble().toString())} hrs";
}

bool isTomorrow(DateTime localDate) {
  final now = DateTime.now();

  final tomorrow = DateTime(
    now.year,
    now.month,
    now.day + 1,
  );

  return localDate.year == tomorrow.year &&
      localDate.month == tomorrow.month &&
      localDate.day == tomorrow.day;
}


Future showToast(
  String message, {
  Color backgroundColor = const Color(0xffF0F0F0),
}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.black,
      fontSize: 16.0);
}


String formatDate(DateTime dt) =>
    '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

String formatDuration(Duration d) {
  final h = d.inHours.toString().padLeft(2, '0');
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}




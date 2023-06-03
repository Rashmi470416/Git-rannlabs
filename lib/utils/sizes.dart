import 'package:flutter/material.dart';

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

vGap(double height) {
  return SizedBox(
    height: height,
  );
}

hGap(double width) {
  return SizedBox(width: width);
}

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: SizedBox(
       height: 20,
      width: getWidth(context),
      child: Center(child: Text(message))),
    backgroundColor: Colors.teal,
  ));
}

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: SizedBox(
      height: 20,
      child: Center(child: Text(message))),
    backgroundColor: Colors.red,
  ));
}

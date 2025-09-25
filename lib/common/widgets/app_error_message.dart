import 'package:flutter/material.dart';

class AppErrorMessage extends StatelessWidget {
  const AppErrorMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}

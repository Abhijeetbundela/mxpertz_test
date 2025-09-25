import 'package:flutter/material.dart';

import 'loader.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.btnColor = Colors.blue,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color btnColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        backgroundColor: WidgetStatePropertyAll<Color>(
          btnColor.withValues(alpha: isLoading ? 0.5 : 1),
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: Loader())
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
    return child;
  }
}

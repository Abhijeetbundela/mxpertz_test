import 'package:flutter/material.dart';
import 'package:mxpertz_test/core/constants/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.btnColor = AppColors.blueColor,
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
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        backgroundColor: WidgetStatePropertyAll<Color>(
          btnColor.withValues(alpha: isLoading ? 0.5 : 1),
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
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

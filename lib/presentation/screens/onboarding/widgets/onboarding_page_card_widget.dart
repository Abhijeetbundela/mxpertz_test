import 'package:flutter/material.dart';
import 'package:mxpertz_test/domain/entities/onboarding_page_item.dart';

class OnboardingPageCardWidget extends StatelessWidget {
  final OnboardingPageItem item;

  const OnboardingPageCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Image.asset(item.imagePath, fit: BoxFit.contain),
    );
  }
}

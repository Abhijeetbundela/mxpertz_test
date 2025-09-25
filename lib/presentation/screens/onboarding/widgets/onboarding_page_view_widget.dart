import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mxpertz_test/domain/entities/onboarding_page_item.dart';
import 'package:mxpertz_test/presentation/blocs/onboarding/onboarding_bloc.dart';

import 'onboarding_page_card_widget.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingPageItem> pages;

  const OnboardingPageViewWidget({
    super.key,
    required this.pageController,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: pages.length,
      onPageChanged: (index) {
        context.read<OnboardingBloc>().add(PageChangedEvent(index));
      },
      itemBuilder: (context, index) {
        return OnboardingPageCardWidget(item: pages[index]);
      },
    );
  }
}

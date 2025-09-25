import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mxpertz_test/domain/entities/onboarding_page_item.dart';
import 'package:mxpertz_test/presentation/blocs/onboarding/onboarding_bloc.dart';

import 'onboarding_button/gradient_button_with_double_dashed_border.dart';

class OnboardingControlsWidget extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingPageItem> pages;

  const OnboardingControlsWidget({
    super.key,
    required this.pageController,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final OnboardingPageItem currentItem = pages[state.currentPageIndex];
        final bool isLastPage = state.currentPageIndex == pages.length - 1;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentItem.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentItem.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: false,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: GradientButtonWithDoubleDashedBorder(
                          onPressed: () {},
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                            SkipOnboardingEvent(),
                          );
                        },
                        child: const Text(
                          'Skip>>',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      GradientButtonWithDoubleDashedBorder(
                        onPressed: () {
                          if (!isLastPage) {
                            pageController.animateToPage(
                              state.currentPageIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                          context.read<OnboardingBloc>().add(NextPageEvent());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

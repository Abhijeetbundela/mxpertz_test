import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mxpertz_test/core/constants/app_colors.dart';
import 'package:mxpertz_test/core/constants/asset_paths.dart';
import 'package:mxpertz_test/core/di/injector.dart';
import 'package:mxpertz_test/domain/entities/onboarding_page_item.dart';
import 'package:mxpertz_test/presentation/blocs/onboarding/onboarding_bloc.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';

import 'widgets/onboarding_controls_widget.dart';
import 'widgets/onboarding_page_view_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingPageItem> _onboardingPagesData = [
    const OnboardingPageItem(
      imagePath: AssetPaths.onboarding1,
      title: 'ONLINE PAYMENT',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum.',
    ),
    const OnboardingPageItem(
      imagePath: AssetPaths.onboarding2,
      title: 'ONLINE SHOPPING',
      description:
          'Pharetra quam elementum massa, viverra. Ut turpis consectetur.',
    ),
    const OnboardingPageItem(
      imagePath: AssetPaths.onboarding3,
      title: 'HOME DELIVER SERVICE',
      description:
          'Elementum tempus egestas sed sed risus pretium quam vulputate dignissim.',
    ),
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(getIt()),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.isOnboardingCompleteNavigateToLogin) {
            context.go(RouterPaths.login);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.blueColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: OnboardingPageViewWidget(
                    pageController: _pageController,
                    pages: _onboardingPagesData,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: OnboardingControlsWidget(
                    pageController: _pageController,
                    pages: _onboardingPagesData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

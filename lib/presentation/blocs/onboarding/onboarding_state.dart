part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPageIndex;
  final bool isOnboardingCompleteNavigateToLogin;

  const OnboardingState({
    this.currentPageIndex = 0,
    this.isOnboardingCompleteNavigateToLogin = false,
  });

  OnboardingState copyWith({
    int? currentPageIndex,
    bool? isOnboardingCompleteNavigateToLogin,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isOnboardingCompleteNavigateToLogin: isOnboardingCompleteNavigateToLogin ?? this.isOnboardingCompleteNavigateToLogin,
    );
  }

  @override
  List<Object> get props => [currentPageIndex, isOnboardingCompleteNavigateToLogin];
}
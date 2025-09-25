import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mxpertz_test/core/services/auth_session_service.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int _totalOnboardingPages = 3;
  final AuthSessionService _authSessionService;

  OnboardingBloc(this._authSessionService) : super(const OnboardingState()) {
    on<NextPageEvent>(_onNextPage);
    on<SkipOnboardingEvent>(_onSkipOnboarding);
    on<PageChangedEvent>(_onPageChanged);
  }

  void _onPageChanged(PageChangedEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }

  Future<void> _onNextPage(
    NextPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.currentPageIndex < _totalOnboardingPages - 1) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex + 1));
    } else {
      await _authSessionService.setOnboardingCompleted(true);
      emit(state.copyWith(isOnboardingCompleteNavigateToLogin: true));
    }
  }

  Future<void> _onSkipOnboarding(
    SkipOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await _authSessionService.setOnboardingCompleted(true);
    emit(state.copyWith(isOnboardingCompleteNavigateToLogin: true));
  }
}

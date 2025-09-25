import 'package:mxpertz_test/core/services/auth_session_service.dart';
import 'package:mxpertz_test/data/repositories/auth_repository.dart';
import 'package:mxpertz_test/data/repositories/firestore_repository.dart';
import 'package:mxpertz_test/presentation/blocs/auth/signup/signup_event.dart';
import 'package:mxpertz_test/presentation/blocs/auth/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(
    this._authRepository,
    this._firestoreUseCase,
    this._authSessionService,
  ) : super(const SignupLoading(false)) {
    on<SignupErrorEvent>(_errorEvent);

    on<SignupRegisterEvent>(_signupRegisterEvent);
  }

  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreUseCase;
  final AuthSessionService _authSessionService;

  void _errorEvent(SignupErrorEvent event, emit) {
    emit(const SignupLoading(false));
    emit(SignupError(event.message));
  }

  void _signupRegisterEvent(SignupRegisterEvent event, emit) async {
    emit(const SignupLoading(true));
    try {
      final user = _authRepository.getCurrentUser();

      if (user != null) {

        final data = await _firestoreUseCase.setUserById(
          id: user.id,
          name: event.name,
          email: event.email,
          phoneNumber: user.phoneNumber,
        );

        final isSet = await _authSessionService.setSession(data);
        if (isSet) {
          emit(const SignupSuccess());
        } else {
          const SignupError('Something went wrong');
        }
        emit(const SignupSuccess());
      } else {
        emit(const SignupError('Something went wrong'));
      }
    } on Exception catch (e) {
      emit(SignupError('Failed to Register: $e'));
    }
    emit(const SignupLoading(false));
  }
}

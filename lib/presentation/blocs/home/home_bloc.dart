import 'package:mxpertz_test/core/services/auth_session_service.dart';
import 'package:mxpertz_test/core/services/shared_prefs_helper.dart';
import 'package:mxpertz_test/data/repositories/firestore_repository.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_event.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._firestoreRepository, this._authSessionService,  this._prefsHelper,)
    : super(const HomeLoadingState()) {
    on<GetUsersEvent>(_onGetUsers);
    on<LogoutUserEvent>(_onLogoutPressed);
  }

  final SharedPrefsHelper _prefsHelper;
  final FirestoreRepository _firestoreRepository;
  final AuthSessionService _authSessionService;

  Future<void> _onGetUsers(GetUsersEvent event, Emitter<HomeState> emit) async {
    try {
      final users = await _fetchUsers();
      emit(GetUsersState(users));
    } on Exception catch (e) {
      emit(HomeErrorState('Failed to fetch users: $e'));
    }
  }

  Future<UserEntity?> _fetchUsers() async {
    final user = _prefsHelper.getUserEntity();
    if (user == null) {
      return null;
    }
    final dbUser = await _firestoreRepository.getUserById(userId: user.id);
    return dbUser;
  }

  Future<void> _onLogoutPressed(
    final LogoutUserEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoadingState());
    try {
      await _authSessionService.signOut();
      emit(const LogoutUserState());
    } on Exception catch (e) {
      emit(HomeErrorState('Failed to logout home: $e'));
    }
  }
}

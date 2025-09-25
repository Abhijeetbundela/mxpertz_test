import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mxpertz_test/common/widgets/app_spinner.dart';
import 'package:mxpertz_test/core/di/injector.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_bloc.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_event.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_state.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';
import 'package:mxpertz_test/presentation/screens/home/widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(getIt(), getIt(), getIt())..add(GetUsersEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is LogoutUserState) {
            context.go(RouterPaths.login);
          }
        },
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          return Scaffold(
            appBar: const HomeAppBar(),
            body: UsersDetails(state: homeBloc.state),
          );
        },
      ),
    );
  }
}

class UsersDetails extends StatelessWidget {
  const UsersDetails({required this.state, super.key});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    switch (state) {
      case HomeLoadingState _:
        return const Center(child: AppSpinner());
      case HomeErrorState _:
        final errorState = state as HomeErrorState;
        return Text(errorState.message);
      case GetUsersState _:
        final usersState = state as GetUsersState;
        return usersState.user == null
            ? Text("No User Found")
            : Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usersState.user!.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usersState.user!.email,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        usersState.user!.phoneNumber,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              );
      default:
        return SizedBox.shrink();
    }
  }
}

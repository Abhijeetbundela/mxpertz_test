import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mxpertz_test/core/constants/asset_paths.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_bloc.dart';
import 'package:mxpertz_test/presentation/blocs/home/home_event.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(AssetPaths.appLogo,height: 32 ,),
      centerTitle: true,
      elevation: 0,
      actions: [_LogoutButton()],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showLogoutDialog(context),
      icon: const Icon(Icons.logout),
      tooltip: "Logout",
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are You Sure You Want To Logout"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HomeBloc>().add(LogoutUserEvent());
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}

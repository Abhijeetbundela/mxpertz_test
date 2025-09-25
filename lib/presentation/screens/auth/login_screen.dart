import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mxpertz_test/common/widgets/app_primary_button.dart';
import 'package:mxpertz_test/core/constants/app_colors.dart';
import 'package:mxpertz_test/core/constants/app_constants.dart';
import 'package:mxpertz_test/core/constants/asset_paths.dart';
import 'package:mxpertz_test/core/di/injector.dart';
import 'package:mxpertz_test/core/utils/validators.dart';
import 'package:mxpertz_test/presentation/blocs/auth/login/login_bloc.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(getIt()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state) {
            case OtpSent _:
              context.push(
                RouterPaths.otp,
                extra: {
                  'verificationId': state.verificationId,
                  'phoneNumber': state.phoneNumber,
                },
              );
              return;
            case LoginError _:
              final m = ScaffoldMessenger.of(context);
              m.hideCurrentSnackBar();
              m.showSnackBar(SnackBar(content: Text(state.message)));
              return;
            case _:
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading && state.isLoading;
          final bloc = context.read<LoginBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("")),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetPaths.appLogo,scale: 3,),
                    SizedBox(height: 32),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Login to continue",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      enabled: !isLoading,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        labelText: "Phone",
                        prefix: const Text('+91 '),
                      ),
                      validator: (value) => Validators.phoneValidator(value),
                    ),
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bloc.add(
                            SendOtpEvent('+91${_phoneController.text.trim()}'),
                          );
                        }
                      },
                      text: "Send Otp",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

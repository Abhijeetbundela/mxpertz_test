import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mxpertz_test/common/widgets/app_primary_button.dart';
import 'package:mxpertz_test/core/di/injector.dart';
import 'package:mxpertz_test/presentation/blocs/auth/signup/signup_bloc.dart';
import 'package:mxpertz_test/presentation/blocs/auth/signup/signup_event.dart';
import 'package:mxpertz_test/presentation/blocs/auth/signup/signup_state.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email';
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter name';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(getIt(), getIt(), getIt()),
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          switch (state) {
            case SignupSuccess _:
              final m = ScaffoldMessenger.of(context);
              m.hideCurrentSnackBar();
              m.showSnackBar(SnackBar(content: Text("Registered Successfully")));
              context.go(RouterPaths.home);
              return;
            case SignupError _:
              final m = ScaffoldMessenger.of(context);
              m.hideCurrentSnackBar();
              m.showSnackBar(SnackBar(content: Text(state.message)));
            case _:
          }
        },
        builder: (context, state) {
          final isLoading = state is SignupLoading && state.isLoading;
          final bloc = context.read<SignupBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("")),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Create Account!",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      enabled: !isLoading,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: _nameValidator,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: !isLoading,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bloc.add(
                            SignupRegisterEvent(
                              _nameController.text,
                              _emailController.text,
                            ),
                          );
                        }
                      },
                      text: "Register",
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

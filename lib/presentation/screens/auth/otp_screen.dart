import 'package:mxpertz_test/common/widgets/app_primary_button.dart';
import 'package:mxpertz_test/core/constants/app_colors.dart';
import 'package:mxpertz_test/core/di/injector.dart';
import 'package:mxpertz_test/core/constants/app_constants.dart';
import 'package:mxpertz_test/presentation/blocs/auth/otp/otp_bloc.dart';
import 'package:mxpertz_test/presentation/blocs/auth/otp/otp_event.dart';
import 'package:mxpertz_test/presentation/blocs/auth/otp/otp_state.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.verificationId,
    required this.phoneNumber,
    super.key,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController(text: '');

  String? _verificationId;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();

    _verificationId = widget.verificationId;
    _phoneNumber = widget.phoneNumber;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.blueColor),
    );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: AppColors.blueColor,
    //   ),
    // );

    return BlocProvider(
      create: (_) =>
          OtpBloc(getIt(), getIt(), getIt())
            ..add(OtpCodeResent(_verificationId ?? '', _phoneNumber ?? '')),
      child: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          switch (state) {
            case Registered _:
              context.go(RouterPaths.home);
              return;
            case NotRegistered _:
              context.go(RouterPaths.signup);
              return;
            case OtpError _:
              final m = ScaffoldMessenger.of(context);
              m.hideCurrentSnackBar();
              m.showSnackBar(SnackBar(content: Text(state.message)));
            case OtpResent _:
              _verificationId = state.verificationId;
              _phoneNumber = state.phoneNumber;
              return;
            case _:
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpLoading && state.isLoading;
          final bloc = context.read<OtpBloc>();

          int countdownRemaining = AppConstants.otpCountdownSeconds;
          bool canResend = true;

          if (state is OtpTick) {
            _verificationId = state.verificationId;
            _phoneNumber = state.phoneNumber;
            countdownRemaining = state.countdownRemaining;
            canResend = state.canResend;
          }

          final Widget formWidget = Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Otp Verification",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Enter the verification code we just sent on your number.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColors.greyColor,
                  ),
                ),
                SizedBox(height: 32),

                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  // submittedPinTheme: submittedPinTheme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter OTP';
                    }
                    if (value.length < 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin){
                    _otpController.text = pin;
                  },
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  isLoading: isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _verificationId != null) {
                      bloc.add(
                        VerifyOtpEvent(
                          _verificationId!,
                          _otpController.text.trim(),
                        ),
                      );
                    }
                  },
                  text: "Verify",
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      canResend
                          ? "Didn't Receive Code"
                          : 'Resend in ${countdownRemaining.toString().padLeft(2, '0')}',
                    ),
                    TextButton(
                      onPressed: canResend
                          ? () {
                              if (isLoading) {
                                return;
                              }
                              if (_phoneNumber != null) {
                                bloc.add(OtpResendPressed(_phoneNumber!));
                              }
                            }
                          : null,
                      child: Text("Resend"),
                    ),
                  ],
                ),
              ],
            ),
          );

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: formWidget,
            ),
          );
        },
      ),
    );
  }
}

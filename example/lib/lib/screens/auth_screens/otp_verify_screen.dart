part of 'auth_screen.dart';

/// Widget for the OTP verification screen during password reset.
class OtpVerifyScreen extends StatelessWidget {
  /// Key for accessing the form state.
  final formKey = GlobalKey<FormState>();

  /// Controller for the OTP input field.
  final controller = TextEditingController();

  /// The email associated with the user.
  final String email;

  /// The user ID associated with the user.
  final String userId;

  /// Constructs an [OtpVerifyScreen] widget.
  ///
  /// [key] is an optional parameter used for widget identification.
  /// [email] is the email associated with the user.
  /// [userId] is the user ID associated with the user.
  OtpVerifyScreen({
    Key? key,
    required this.email,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      appBar: const AppBarCommon(),
      body: SingleChildScrollView(
        child: AppInkWell(
          onTap: () => hideAppKeyboard,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "OTP Verification",
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
                AppText(
                  "Enter the verification code we have just sent to your e-mail address",
                  maxLines: 5,
                  height: 1,
                  fontSize: 12.sp,
                  color: AppColors.oceanBlue,
                ).paddingOnly(bottom: 70.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      length: 4,
                      controller: controller,
                      defaultPinTheme: PinTheme(
                        height: 63.w,
                        width: 67.w,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19.r),
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.oceanBlue,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) => AppValidators.validateOTP(value),
                      errorPinTheme: PinTheme(
                        height: 63.w,
                        width: 67.w,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBorder,
                          borderRadius: BorderRadius.circular(19.r),
                          border: Border.all(color: Colors.red),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        height: 63.w,
                        width: 67.w,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBorder,
                          borderRadius: BorderRadius.circular(19.r),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                      ),
                      onCompleted: (val) {},
                    ),
                  ],
                ).paddingSymmetric(vertical: 30.h),
                BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordVerifySuccess) {
                      context.pushReplacement(ResetPasswordScreen(
                        userId: userId,
                      ));
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                      builder: (context, isEarner) {
                        return AppCommonButton(
              context: context,
                          title: "Verify",
                          width: AppConfig.width * 0.8,
                          backGroundColor:
                          (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                          onTap: () => _onSubmit(context),
                          loading: state is ForgotPasswordVerifyLoading,
                        );
                      },
                    );
                  },
                ).paddingSymmetric(vertical: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<TimeOtpToggleCubit, TimeOtpToggleState>(
                      builder: (context, state) {
                        if (state.time > 0) {
                          return Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: AppText(
                                    "Resend code in ",
                                    fontSize: 14.sp,
                                    color: AppColors.oceanBlue,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                WidgetSpan(
                                  child: AppText(
                                    "${state.time}s",
                                    fontSize: 14.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: AppText(
                                  "Didn’t receive code? ",
                                  fontSize: 14.sp,
                                  color: AppColors.oceanBlue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              WidgetSpan(
                                child: BlocConsumer<ForgotPasswordBloc,
                                    ForgotPasswordState>(
                                  listener: (context, forget) {
                                    if (forget is ForgotPasswordSendSuccess) {
                                      context
                                          .read<TimeOtpToggleCubit>()
                                          .startTime();
                                    }
                                  },
                                  builder: (context, forget) {
                                    return AppInkWell(
                                      onTap: () =>
                                      forget is! ForgotPasswordSendLoading &&
                                          state.resendAvailable
                                          ? _onResendTap(context)
                                          : null,
                                      child: forget is ForgotPasswordSendLoading
                                          ? SizedBox(
                                          height: 20.h,
                                          width: 20.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.w,
                                            color: AppColors.primaryColor,
                                          ))
                                          : AppText(
                                        "Resend",
                                        fontSize: 14.sp,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                100.yHeight,
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
    );
  }

  void _onResendTap(BuildContext context) {
    context.read<ForgotPasswordBloc>().forgot(
      email: email,
      listener: false,
      user_role: context.read<ChooseUserToggleBloc>().state.name,
    );
  }

  void _onSubmit(BuildContext context) {
    if (formKey.currentState?.validate() == false) return;
    if (controller.text.length > 3) {
      hideAppKeyboard;
      context.read<ForgotPasswordBloc>().forgotPasswordVerify(
        userId: userId,
        otp: controller.text,
      );
    } else {
      showSnackBar(message: 'Enter OTP');
    }
  }
}

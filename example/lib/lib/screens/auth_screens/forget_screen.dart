part of 'auth_screen.dart';

/// Widget for the "Forgot Password" screen.
class ForgetPassword extends StatelessWidget {
  /// Key for accessing the form state.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller for the email text field.
  final TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "dpk@gmail.com" : "",
  );

  /// Constructs a [ForgetPassword] widget.
  ///
  /// [key] is an optional parameter used for widget identification.
  ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      appBar: const AppBarCommon(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                "Forgot Password",
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ).paddingOnly(bottom: 5.h),
              BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                builder: (context, isEarner) {
                  return AppText(
                    (isEarner==RegisterRoleConst.EARNER)
                        ? "Recover your account by entering your email."
                        : "You can recover your account by entering your linked email.",
                    fontSize: 12.sp,
                    height: 0.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.oceanBlue,
                  );
                },
              ).paddingOnly(bottom: 70.h),
              AppTextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                hintText: "Email",
                prefixIcon: Icon(CupertinoIcons.mail_solid,size: 20.h),
                validator: (v) =>
                    AppValidators.validateEmail(v),
              ).paddingSymmetric(vertical: 30.h),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSendSuccess && state.listener) {
                    context.read<TimeOtpToggleCubit>().startTime();
                    context.push(OtpVerifyScreen(
                      userId: state.model.userData?.id ?? "",
                      email: emailController.text,
                    ));
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                    builder: (context, isEarner) {
                      return AppCommonButton(
              context: context,
                        title: "Send Code",
                        width: AppConfig.width * 0.8,
                        backGroundColor:
                        (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                        loading: state is ForgotPasswordSendLoading,
                        onTap: () {
                          if (formKey.currentState?.validate() == false)
                            return;
                          context
                              .read<ForgotPasswordBloc>()
                              .forgot(email: emailController.text,
                            user_role: context.read<ChooseUserToggleBloc>().state.name,
                          );
                        },
                      );
                    },
                  );
                },
              ).paddingSymmetric(vertical: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Already have an account? ",
                    fontSize: 14.sp,
                    color: AppColors.oceanBlue,
                    fontWeight: FontWeight.w400,
                  ),
                  AppText(
                    "Sign in",
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    onTap: () {
                      context.push(LoginScreen());
                    },
                  )
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
    );
  }
}

part of 'auth_screen.dart';

/// Screen for resetting the password.
class ResetPasswordScreen extends StatelessWidget {
  /// Indicates whether the screen is navigated from the profile screen.
  final bool fromProfile;

  /// The user ID for resetting the password.
  final String userId;

  /// Constructs a new [ResetPasswordScreen] instance.
  ///
  /// Parameters:
  /// - [fromProfile]: Indicates whether the screen is navigated from the profile screen.
  /// - [userId]: The user ID for resetting the password.
  ResetPasswordScreen({
    super.key,
    this.fromProfile = false,
    this.userId = "",
  }) {
    disableToggleBlocs();
  }

  /// Form key for validating the form fields.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller for the old password text field.
  final TextEditingController oldPasswordController =
  TextEditingController();

  /// Controller for the new password text field.
  final TextEditingController passwordController =
  TextEditingController();

  /// Controller for the confirmation password text field.
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    "Reset Password",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    "Enter  a new password",
                    height: 1,
                    fontSize: 12.sp,
                    color: AppColors.oceanBlue,
                  ),
                ],
              ).paddingOnly(bottom: 70.h),
              if (fromProfile) ...[
                BlocBuilder<ShowOldPasswordToggleBloc, bool>(
                  builder: (context, state) {
                    return AppTextFormField(
                      hintText: '********',
                      obscureText: state,
                      controller: oldPasswordController,
                      prefixIcon: Icon(CupertinoIcons.padlock_solid, size: 25
                          .h,),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          context.read<ShowOldPasswordToggleBloc>().add(!state);
                        },
                        child: Icon(
                          !state
                              ? CupertinoIcons.eye_solid
                              : CupertinoIcons.eye_slash_fill,
                          size: 23.h,
                        ),
                      ),
                      validator: (v) => AppValidators.validatePassword(v),
                    );
                  },
                ).paddingOnly(bottom: 10.h),
              ],
              BlocBuilder<ShowPasswordToggleBloc, bool>(
                builder: (context, obscureText) {
                  return AppTextFormField(
                    obscureText: obscureText,
                    hintText: "Password",
                    controller: passwordController,
                    prefixIcon: Icon(CupertinoIcons.padlock_solid, size: 25
                          .h,),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context
                            .read<ShowPasswordToggleBloc>()
                            .add(!obscureText);
                      },
                      child: Icon(
                        !obscureText
                            ? CupertinoIcons.eye_solid
                            : CupertinoIcons.eye_slash_fill,
                        size: 23.h,
                      ),
                    ),
                    validator: (v) => AppValidators.validatePassword(v),
                  );
                },
              ).paddingOnly(bottom: 10.h),
              BlocBuilder<ShowConPasswordToggleBloc, bool>(
                builder: (context, obscureText) {
                  return AppTextFormField(
                    hintText: 'Re-enter password',
                    obscureText: obscureText,
                    prefixIcon: Icon(CupertinoIcons.padlock_solid, size: 25
                          .h,),
                    controller: confirmPasswordController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        context
                            .read<ShowConPasswordToggleBloc>()
                            .add(!obscureText);
                      },
                      child: Icon(
                        !obscureText
                            ? CupertinoIcons.eye_solid
                            : CupertinoIcons.eye_slash_fill,
                        size: 23.h,
                      ),
                    ),
                    validator: (v) =>
                        AppValidators.validateConfirmPassword(
                          passwordController.text,
                          confirmPasswordController.text,
                        ),
                  );
                },
              ).paddingOnly(bottom: 30.h),
              BlocConsumer<CreateNewPasswordBloc, CreateNewPasswordState>(
                listener: (context, state) {
                  if (state is CreateNewPasswordSuccess) {
                    if(fromProfile){
                      context.pop();
                    }else {
                      context.pushAndRemoveUntil(UpdatedPasswordScreen(
                      fromProfile: fromProfile,
                    ));
                    }
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                    builder: (context, isEarner) {
                      return AppCommonButton(
              context: context,
                        title: "Reset Password",
                        width: AppConfig.width * 0.8,
                        backGroundColor: (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                        loading: state is CreateNewPasswordLoading,
                        onTap: () async {
                          if (formKey.currentState?.validate() == false) return;
                          hideAppKeyboard;
                          context.read<CreateNewPasswordBloc>()
                              .createNewPassword(
                            userId: userId,
                            context: context,
                            password: passwordController.text,
                            oldPassword: oldPasswordController.text,
                            conPassword: confirmPasswordController.text,
                          );
                        },
                      );
                    },
                  );
                },
              ).paddingOnly(bottom: 20.h),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
    );
  }
}

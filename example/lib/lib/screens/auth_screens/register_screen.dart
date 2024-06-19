part of'auth_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  /// Flag to determine if the privacy policy is enabled.
  bool privacyPolicyEnable = false;

  /// Global key for the form used for registration.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller for managing the email input field.
  final TextEditingController emailController = TextEditingController();

  /// Controller for managing the name input field.
  final TextEditingController nameController = TextEditingController();

  /// Controller for managing the password input field.
  final TextEditingController passwordController = TextEditingController();

  /// Controller for managing the confirm password input field.
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      appBar: const AppBarCommon(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SocialLoginBloc, SocialLoginState>(
            listener: (context, state) {
              if (state is SocialLoginSuccess) {
                final isEarnerStripeConnection =
                    context.read<ChooseUserToggleBloc>().state;
                gotoDashboard(
                  context,
                  isEarnerStripeConnection: (isEarnerStripeConnection==RegisterRoleConst.EARNER),
                );
              }
            },
          ),
          BlocListener<RegisterAuthBloc, RegisterAuthState>(
            listener: (context, state) {
              if (state is ResisterAuthLoadedSuccess) {
                final isEarnerStripeConnection =
                    context.read<ChooseUserToggleBloc>().state;
                gotoDashboard(
                  context,
                  isEarnerStripeConnection: (isEarnerStripeConnection==RegisterRoleConst.EARNER),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "Sign Up",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ).paddingOnly(bottom: 5.h),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "Enter your credentials to continue.",
                      fontSize: 14.sp,
                      height: 0.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.oceanBlue,
                    ),
                  ],
                ).paddingOnly(bottom: 20.h),
                AppTextFormField(
                  controller: nameController,
                  hintText: "Name",
                  prefixIcon: Icon(CupertinoIcons.person_fill,size: 20.h,),
                  validator: AppValidators.validateMessage,
                ).paddingSymmetric(vertical: 10.h),
                AppTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: Icon(CupertinoIcons.mail_solid,size: 20.h,),
                  validator: (v) => AppValidators.validateEmail(v),
                ).paddingOnly(bottom: 10.h),
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
                      validator: (v) => AppValidators.validateConfirmPassword(
                        passwordController.text,
                        confirmPasswordController.text,
                      ),
                    );
                  },
                ).paddingOnly(bottom: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<NumberPickerChangedToggleBloc, int>(
                      builder: (context, state) {
                        return AppCheckBox(
                          context: context,
                          value: privacyPolicyEnable,
                          title: "",
                          onTap: (v) {
                            privacyPolicyEnable = !privacyPolicyEnable;
                            context
                                .read<NumberPickerChangedToggleBloc>()
                                .rebuild();
                          },
                        );
                      },
                    ).paddingOnly(top: 5.h),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.oceanBlue,
                          ),
                          children: [
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: ' and ',style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.oceanBlue,
                            ),),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ).paddingOnly(bottom: 30.h).paddingSymmetric(horizontal: 10.w),
                BlocBuilder<RegisterAuthBloc, RegisterAuthState>(
                  builder: (context, state) {
                    return BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                      builder: (context, isEarner) {
                        return AppCommonButton(
              context: context,
                          title: "Sign up",
                          width: AppConfig.width * 0.8,
                          loading: state is ResisterAuthLoading,
                          backGroundColor:
                          (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                          onTap: () async {
                            if (formKey.currentState?.validate() == false)
                              return;
                            if (!privacyPolicyEnable) {
                              showSnackBar(
                                message: "Please agree to the Terms of Use.",
                              );
                              return;
                            }
                            initiateRegistration(context);
                          },
                        );
                      },
                    );
                  },
                ).paddingSymmetric(vertical: 10.h),
                SizedBox(
                  height: 44.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2.w,
                        width: AppConfig.width * 0.2,
                        color: AppColors.oceanBlue,
                      ).paddingOnly(right: 10.w),
                      AppText(
                        "or sign up with",
                        fontSize: 14.sp,
                        color: AppColors.oceanBlue,
                        fontWeight: FontWeight.w500,
                      ).paddingOnly(right: 10.w),
                      Container(
                        height: 2.w,
                        width: AppConfig.width * 0.2,
                        color: AppColors.oceanBlue,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<SocialLoginBloc, SocialLoginState>(
                  builder: (context, state) {
                    final socialLoginBloc = context.read<SocialLoginBloc>();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialWidget(
                          loading: state is SocialGoogleLoginLoading,
                          onTap: () => socialLoginBloc.googleLogin(),
                          icon: const AppCommonImage(
                            imagePath: AppImagesPath.googleIcon,
                          ),
                        ).paddingSymmetric(horizontal: 5.w),
                        // socialWidget(
                        //   loading: state is SocialFacebookLoginLoading,
                        //   onTap: () => socialLoginBloc.facebookLogin(),
                        //   icon: const AppCommonImage(
                        //     imagePath: AppImagesPath.facebookIcon,
                        //   ),
                        // ).paddingSymmetric(horizontal: 5.w),
                        if (Platform.isIOS)
                          socialWidget(
                            loading: state is SocialAppleLoginLoading,
                            onTap: () => socialLoginBloc.appleLogin(),
                            icon: const Icon(Icons.apple),
                          ).paddingSymmetric(horizontal: 5.w),
                      ],
                    );
                  },
                ).paddingSymmetric(vertical: 20.h),
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
                      color: Color(0xffEF9245),
                      fontWeight: FontWeight.w700,
                      onTap: () {
                        context.push(LoginScreen());
                      },
                    )
                  ],
                ).paddingOnly(bottom: 30.h),
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
    );
  }
  /// Initiates the registration authentication process by dispatching an event to the [RegisterAuthBloc].
  ///
  /// This method takes the necessary user input from the controllers and sends it as form data to the authentication bloc.
  ///
  /// Parameters:
  /// - [emailController]: The controller managing the email input field.
  /// - [passwordController]: The controller managing the password input field.
  /// - [nameController]: The controller managing the name input field.
  /// - [confirmPasswordController]: The controller managing the confirm password input field.
  /// - [context]: The BuildContext for accessing the Bloc and other context-related functionalities.
  ///
  /// Returns:
  /// - None.
  Future<void> initiateRegistration(BuildContext context) async {
    context.read<RegisterAuthBloc>().resisterAuth(FormData.fromMap({
          'email': emailController.text,
          'password': passwordController.text,
          "name": nameController.text,
          "reenterPassword": confirmPasswordController.text,
          "user_role": context.read<ChooseUserToggleBloc>().state.name,
          'deviceType': AppEndPoint.deviceType,
          'deviceToken': await getFcmToken(),
        }));
  }

}

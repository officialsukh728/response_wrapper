part of 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  /// Global key for the login form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller for managing the email input field.
  final TextEditingController emailController = TextEditingController(
      text: kDebugMode ? "advertiser@gmail.com" : "");

  /// Controller for managing the password input field.
  final TextEditingController passwordController = TextEditingController(
      text: kDebugMode ? "12345678" : "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.peachCream,
      appBar: AppBarCommon(
        onPressed: () => context.pushAndRemoveUntil(const ChooseUserScreen()),
      ),
      body: BlocListener<SocialLoginBloc, SocialLoginState>(
        listener: (context, state) {
          if (state is SocialLoginSuccess) {
            gotoDashboard(context);
          }
        },
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
                      "Sign In",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ).paddingOnly(bottom: 5.h),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "Enter your credentials to continue.",
                      height: 0.5,
                      fontSize: 12.sp,
                      color: AppColors.oceanBlue,
                    ),
                  ],
                ).paddingOnly(bottom: 70.h),
                AppTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: "Enter Email",
                  prefixIcon: Icon(CupertinoIcons.mail_solid, size: 20.h,),
                  validator: (v) => AppValidators.validateEmail(v),
                ).paddingSymmetric(vertical: 10.h),
                BlocBuilder<ShowPasswordToggleBloc, bool>(
                  builder: (context, state) {
                    return AppTextFormField(
                      hintText: "**********",
                      obscureText: state,
                      controller: passwordController,
                      prefixIcon: Icon(CupertinoIcons.padlock_solid, size: 25
                          .h,),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          context.read<ShowPasswordToggleBloc>().add(!state);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    AppText(
                      "Forgot Password ?",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.oceanBlue,
                      onTap: () => context.push(ForgetPassword()),
                    ),
                  ],
                ).paddingOnly(bottom: 30.h),
                BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                  builder: (context, isEarner) {
                    return BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginLoadedSuccess) {
                          gotoDashboard(context);
                        }
                      },
                      builder: (context, state) {
                        return AppCommonButton(
              context: context,
                          title: "Sign in",
                          backGroundColor:
                          (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                          loading: state is LoginLoading,
                          width: AppConfig.width * 0.8,
                          onTap: () {
                            if (formKey.currentState?.validate() == false)
                              return;
                            context.read<LoginBloc>().login(
                              formKey: formKey,
                              context: context,
                              passwordController: passwordController,
                              emailController: emailController,
                            );
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
                        "or sign in with",
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
                      "Don’t have an account? ",
                      fontSize: 14.sp,
                      color: AppColors.oceanBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    AppText(
                      "Sign Up",
                      fontSize: 14.sp,
                      // color: Colors.teal,
                      color: Color(0xffEF9245),
                      fontWeight: FontWeight.w400,
                      onTap: () {
                        context.push(RegisterScreen());
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

}

Widget socialWidget({
  required Widget icon,
  required Function() onTap,
  bool loading = false,
}) {
  return AppInkWell(
    onTap: onTap,
    child: Container(
      width: 50.h,
      height: 50.h,
      padding: EdgeInsets.all(10.h),
      decoration: const ShapeDecoration(
        color: AppColors.white,
        shape: CircleBorder(),
      ),
      child: loading
          ? const CircularProgressIndicator(
        color: AppColors.primaryColor,
      )
          : Center(child: icon),
    ),
  );
}
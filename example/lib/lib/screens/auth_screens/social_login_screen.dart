part of 'auth_screen.dart';

/// Represents the screen where users can choose to sign in using social media platforms or email.
///
/// Users are presented with options to sign in using Google, Facebook, Apple (if available), or email.
class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(),
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: BlocListener<SocialLoginBloc, SocialLoginState>(
          listener: (context, state) {
            if (state is SocialLoginSuccess) {
              gotoDashboard(context);
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
              builder: (context, isEarner) {
                return FutureBuilder<bool>(
                    future: isAppleSignInSupported(),
                    builder: (context, isIosAvailable) {
                      final socialLoginBloc = context.read<SocialLoginBloc>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(
                            (isEarner==RegisterRoleConst.EARNER)? "Get Paid Through Your Displays" :"Engage your Audience",
                            fontSize: 24.sp,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                          ).paddingOnly(top: 5.h, bottom: 5.h),
                          AppText(
                            (isEarner==RegisterRoleConst.EARNER)?"Just sign in and connect a screen":"Finally, a campaign with real outreach and conversions I can measure.",
                            fontSize: 14.sp,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                            color: AppColors.oceanBlue,
                          ).paddingOnly(bottom: 20.h).paddingSymmetric(horizontal: 30.w),
                          AppCommonImage(
                            height: AppConfig.height * 0.3,
                            width: AppConfig.width,
                            imagePath: AppImagesPath.appSocialLogin,
                          ).paddingOnly(bottom: 20.h),
                          BlocBuilder<SocialLoginBloc, SocialLoginState>(
                            builder: (context, state) {
                              return AppCommonButton(
              context: context,
                                loading: state is SocialGoogleLoginLoading,
                                borderRadius: 48.r,
                                width: AppConfig.width * 0.8,
                                fontWeight: FontWeight.w400,
                                borderColor: AppColors.oceanBlue,
                                backGroundColor: Colors.transparent,
                                title: AppStrings.continueWithGoogle,
                                icon1: Image.asset(
                                  AppImagesPath.googleIcon,
                                  height: 20.h,
                                  width: 20.h,
                                ),
                                onTap: () => socialLoginBloc.googleLogin(),
                              );
                            },
                          ).paddingSymmetric(vertical: 10.h),
                          // BlocBuilder<SocialLoginBloc, SocialLoginState>(
                          //   builder: (context, state) {
                          //     return AppCommonButton(
                          //       loading: state is SocialFacebookLoginLoading,
                          //       borderRadius: 48.r,
                          //       width: AppConfig.width * 0.8,
                          //       fontWeight: FontWeight.w400,
                          //       borderColor: AppColors.oceanBlue,
                          //       backGroundColor: Colors.transparent,
                          //       title: AppStrings.continueWithFacebook,
                          //       icon1: Image.asset(
                          //         AppImagesPath.facebookIcon,
                          //         height: 20.h,
                          //         width: 20.h,
                          //       ),
                          //       onTap: () => socialLoginBloc.facebookLogin(),
                          //     );
                          //   },
                          // ).paddingSymmetric(vertical: 10.h),
                          if (Platform.isIOS && isIosAvailable.data == true)
                            BlocBuilder<SocialLoginBloc, SocialLoginState>(
                              builder: (context, state) {
                                return AppCommonButton(
              context: context,
                                  loading: state is SocialAppleLoginLoading,
                                  borderRadius: 48.r,
                                  width: AppConfig.width * 0.8,
                                  fontWeight: FontWeight.w400,
                                  borderColor: AppColors.oceanBlue,
                                  backGroundColor: Colors.transparent,
                                  title: AppStrings.continueWithApple,
                                  icon1: const Icon(Icons.apple),
                                  onTap: () => socialLoginBloc.appleLogin(),
                                );
                              },
                            ).paddingSymmetric(vertical: 10.h),
                          AppCommonButton(
              context: context,
                            borderRadius: 48.r,
                            width: AppConfig.width * 0.8,
                            fontWeight: FontWeight.w400,
                            borderColor: AppColors.oceanBlue,
                            backGroundColor: Colors.transparent,
                            title: AppStrings.continueWithMail,
                            icon1: const Icon(Icons.email),
                            onTap: () {
                              context.push(LoginScreen());
                            },
                          ).paddingSymmetric(vertical: 10.h),
                        ],
                      );
                    }
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

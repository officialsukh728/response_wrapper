part of 'auth_screen.dart';

/// Represents the screen displayed to users when they first open the app, providing options to sign in or sign up.
///
/// This screen includes an image and text prompting users to get started, along with buttons to sign in or sign up.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: Container(
        height: AppConfig.height,
        width: AppConfig.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(
              AppImagesPath.appGetStarted,
            ),
          ),
        ),
        child: Column(
          children: [
            (AppConfig.height * 0.6).yHeight,
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: AppConfig.height * 0.5,
                    width: AppConfig.width,
                  ),
                  Positioned(
                    top: 50.h,
                    child: Container(
                      height: AppConfig.height,
                      width: AppConfig.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.r),
                            topLeft: Radius.circular(40.r),
                          )),
                      child: BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
                        builder: (context, isEarner) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              0.yHeight
                                  .paddingSymmetric(vertical: 20.h)
                                  .paddingOnly(top: 50.h),
                              AppText(
                                "Get Started",
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                              ).paddingOnly(bottom: 5.h),
                              AppText(
                                (isEarner==RegisterRoleConst.EARNER)?"Show ads & get paid":"Show your ads on any screen anywhere",
                                fontSize: 16.sp,

                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w400,
                                color: AppColors.oceanBlue,
                              ).paddingOnly(bottom: 30.h).paddingSymmetric(horizontal: 20.w),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: AppConfig.width * 0.5 - 35.w,
                    child: Container(
                      height: 70.w,
                      width: 70.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: const BoxDecoration(
                        color: AppColors.babyBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: AppCommonImage(
                            imagePath: AppImagesPath.appLogo,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppCommonButton(
              context: context,
              isPrimary: true,
              title: "Sign in",
              fontSize: 18.sp,
              backGroundColor: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              onTap: () => context.pushReplacement(const SocialLoginScreen()),
            ),
            10.widthBox,
            AppCommonButton(
              context: context,
              title: "Sign up",
              fontSize: 18.sp,
              backGroundColor: AppColors.secondaryColor,
              fontWeight: FontWeight.w700,
              onTap: () => context.push(RegisterScreen()),
            ),
          ],
        ).paddingSymmetric(vertical: 20.h),
      ),
    );
  }
}

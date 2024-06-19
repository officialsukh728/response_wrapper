part of 'auth_screen.dart';

/// Represents the screen displayed after a successful password update.
///
/// Users are informed that their password has been successfully updated and are prompted to either save (if accessed from profile settings) or login again.
class UpdatedPasswordScreen extends StatelessWidget {
  /// Indicates whether the screen was accessed from the user's profile settings.
  final bool fromProfile;

  const UpdatedPasswordScreen({
    super.key,
    required this.fromProfile,
  });

  /// Navigates to the appropriate screen based on the origin of the request.
  Future<void> goto(BuildContext context) async {
    if (fromProfile) {
      gotoDashboard(context);
    } else {
      context.pushAndRemoveUntil(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(leading: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              "Password Updated",
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ).paddingOnly(bottom: 15.h, top: AppConfig.height * 0.15),
            AppCommonImage(
              height: AppConfig.width * 0.4,
              width: AppConfig.width * 0.4,
              imagePath: AppImagesPath.appPasswordUpdate,
            ).paddingOnly(bottom: 10.h),
            AppText(
              "Your password has been updated. Login again to proceed",
              fontSize: 15.sp,
              maxLines: 5,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
              color: AppColors.oceanBlue,
            ).paddingSymmetric(horizontal: 30.w).paddingOnly(bottom: 20.h),
            BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
              builder: (context, isEarner) {
                return AppCommonButton(
              context: context,
                  width: AppConfig.width * 0.8,
                  backGroundColor: (isEarner==RegisterRoleConst.ADVERTISER) ? AppColors.primaryColor : AppColors.secondaryColor,
                  title: fromProfile ? "Save" : "Login",
                  onTap: () => goto(context),
                );
              },
            ).paddingSymmetric(vertical: 10.h),
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }
}

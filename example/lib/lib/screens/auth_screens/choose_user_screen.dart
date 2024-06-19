part of 'auth_screen.dart';

/// Represents the screen where users can choose their role as either an advertiser or an earner.
///
/// Users are presented with options to select their role and proceed to the get started screen.
class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: BlocBuilder<ChooseUserToggleBloc, RegisterRoleConst>(
          builder: (context, isEarner) {
            final chooseBloc=context.read<ChooseUserToggleBloc>();
            return AppInkWell(
              onTap: () => hideAppKeyboard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(child: 0.yHeight),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "welcome to",
                              fontSize: 16.sp,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.start,
                              color: AppColors.oceanBlue,
                            ),
                            AppText(
                              "sample",
                              height: 1,
                              fontSize: 30.sp,
                              fontFamily: AppFonts.righteous,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 20.h),
                  AppText(
                    "I am an",
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    color: AppColors.oceanBlue,
                  ).paddingOnly(top: 10.h),
                  _getContainer(
                    isSelected: isEarner==RegisterRoleConst.ADVERTISER,
                    imagePath: AppImagesPath.appAdvertiser,
                    onTap: () {chooseBloc.add(RegisterRoleConst.ADVERTISER);
                    context.push(const GetStartedScreen());},
                  ),
                  _getContainer(
                    isSelected: isEarner==RegisterRoleConst.EARNER,
                    imagePath: AppImagesPath.appEarner,
                    onTap: () {chooseBloc.add(RegisterRoleConst.EARNER);
                    context.push(const GetStartedScreen());},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Returns a container widget with an image representing a user type.
  Widget _getContainer({
    required String imagePath,
    required bool isSelected,
    required void Function() onTap,
  }) {
    return AppInkWell(
      onTap: onTap,
      child: Container(
        height: 182.h,
        width: AppConfig.width * 0.7,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.blue,
          // border: Border.all(
          //   width: 2.w,
          //   color: isSelected ? Colors.black : Colors.transparent,
          // ),
          borderRadius: BorderRadius.circular(30.r),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}

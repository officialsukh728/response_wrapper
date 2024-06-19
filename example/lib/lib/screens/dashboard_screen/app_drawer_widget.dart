part of 'dashboard.dart';

class DrawerItemModel {
  final String title;
  final String imagePath;
  final void Function() onTap;

  DrawerItemModel({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });
}

List<DrawerItemModel> getDrawerItemList({
  required BuildContext context,
  required ProfileModel profileModel,
}) =>
    <DrawerItemModel>[
      if (profileModel.userData?.stripeResponse == null &&
          profileModel.userData?.userRole == RegisterRoleConst.EARNER.name)
        DrawerItemModel(
          title: "Connect to stripe",
          imagePath: AppImagesPath.appConnectionStripe,
          onTap: () {
            // if (!kDebugMode) return;
            context.pushAndRemoveUntil(ConnectToStripeScreen());
          },
        ),
      DrawerItemModel(
        title: "Home",
        imagePath: AppImagesPath.appHome,
        onTap: () {

        },
      ),
      if (userIsAdvertiser)
        DrawerItemModel(
          title: "Advertisements",
          imagePath: AppImagesPath.appAdvertisements,
          onTap: () {
            // if (!kDebugMode) return;
          },
        )
      else
        DrawerItemModel(
          title: "Screens",
          imagePath: AppImagesPath.appScreens,
          onTap: () {
            // if (!kDebugMode) return;
          },
        ),
      DrawerItemModel(
        title: "Dashboard",
        imagePath: AppImagesPath.appDashboard,
        onTap: () {
          // if (!kDebugMode) return;
          context.pushAndRemoveUntil(const Dashboard());
        },
      ),
      if (userIsAdvertiser)
        DrawerItemModel(
          title: "Payments",
          imagePath: AppImagesPath.appPayments,
          onTap: () {
          },
        )
      else
        DrawerItemModel(
          title: "Earnings",
          imagePath: AppImagesPath.appPayments,
          onTap: () {
          },
        ),
      DrawerItemModel(
        title: "Profile",
        imagePath: AppImagesPath.appProfile,
        onTap: () {
          // if (!kDebugMode) return;
          context.pushAndRemoveUntil(ProfileScreen(profileModel: profileModel));
        },
      ),
      DrawerItemModel(
        title: "Logout",
        imagePath: AppImagesPath.appLogout,
        onTap: () {
          deleteLogoutAccountBottomSheet(
            context: context,
            logout: true,
            profileModel:profileModel,
          );
        },
      ),
    ];

class DashboardDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldStateKey;

  const DashboardDrawer({
    Key? key,
    required this.scaffoldStateKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is! ProfileLoaded) {
          return Drawer(
            child: getCustomLoading(),
          );
        } else {
          final userName = profileState.profileModel.userData?.name ?? "";
          final photo = profileState.profileModel.userData?.photo;
          return Drawer(
            width: AppConfig.width * 0.7,
          child: Column(
            children: [
              SizedBox(
                height: 250.h,
                child: Stack(
                  children: [
                    Container(
                      height: 150.h,
                      width: AppConfig.width * 0.7,
                      color: userIsAdvertiser
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                    ).paddingOnly(bottom: 100.h),
                    Positioned(
                      top: 50.h,
                      left: (AppConfig.width * 0.7) - 35.w,
                      child: AppInkWell(
                        onTap: () =>
                            scaffoldStateKey.currentState?.closeDrawer(),
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 20.sp,
                              color: getUserRole ==
                                      RegisterRoleConst.ADVERTISER.index
                                          .toString()
                                  ? AppColors.primaryColor
                                  : AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60.h,
                      left: (AppConfig.width * 0.35) - 50.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppText("Welcome").paddingOnly(bottom: 10.h),
                          buildAvatarContainer(
                            width: 100.h,
                            height: 100.h,
                            image: photo,
                            name: userName,
                            context: context
                          ).paddingOnly(bottom: 10.h),
                          AppText(
                            userName.toCapitalizeFirstWordOnly(),
                          ).paddingOnly(bottom: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: getDrawerItemList(context: context,profileModel: profileState.profileModel).length,
                  itemBuilder: (context, index) {
                    final item = getDrawerItemList(context: context,profileModel: profileState.profileModel)[index];
                    return AppInkWell(
                      onTap: item.onTap,
                      child: Row(
                        children: [
                          AppCommonImage(
                            width: 20.h,
                            height: 20.h,
                            imagePath: item.imagePath,
                          ).paddingOnly(right: 10.w),
                          AppText(item.title)
                        ],
                      ),
                    ).paddingSymmetric(vertical: 10.h);
                  },
                ),
              ),
            ],
          ),
        );
        }
      },
    );
  }
}

class CustomAppbarWidget extends StatelessWidget {
  final String title;

  const CustomAppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInkWell(
          onTap: () => context.pop(),
          child: Icon(
            CupertinoIcons.arrow_left,
            size: 30.sp,
            color: AppColors.black,
          ),
        ).paddingOnly(right: 10.w),
        Column(
          children: [
            AppText(
              title,
              fontSize: 20.sp,
              maxLines: 10,
            ),
          ],
        )
      ],
    );
  }
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showHelpScreen;
  final bool showNotification;
  final GlobalKey<ScaffoldState> scaffoldStateKey;

  const DashboardAppBar({
    Key? key,
    required this.scaffoldStateKey,
    this.showHelpScreen=true,
    this.showNotification=true,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context) {
    return AppBarCommon(
      leading: true,
      leadingWidget: AppCommonImage(
        onTap: () => toggleDrawer(),
        width: 56.w,
        height: 56.w,
        imagePath: AppImagesPath.appNavigation,
      ).paddingAll(15.w),
      actions: [
        if(showHelpScreen)
        AppInkWell(
          onTap: () => context.pushAndRemoveUntil(HelpScreen()),
          child: Container(
            width: 30.h,
            height: 30.h,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.question,
                size: 20.sp,
                color: Colors.black,
              ),
            ),
          ).paddingOnly(right: 10.w),
        ),
        if(showNotification)
        AppInkWell(
          onTap: () => context.pushAndRemoveUntil(NotificationScreen()),
          child: Container(
            width: 30.h,
            height: 30.h,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: AppCommonImage(
              width: 20.h,
              height: 20.h,
              imagePath: AppImagesPath.appNotification,
            ),
          ).paddingOnly(right: 10.w),
        ),
      ],
    );
  }

  /// Method to toggle the drawer
  void toggleDrawer() {
    if (scaffoldStateKey.currentState?.isDrawerOpen == true) {
      scaffoldStateKey.currentState?.closeDrawer();
    } else {
      scaffoldStateKey.currentState?.openDrawer();
    }
  }
}

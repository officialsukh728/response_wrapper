import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/screens/dashboard_screen/dashboard.dart';
import 'package:sample/utils/assets/app_image_path.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/app_textField.dart';
import 'package:sample/utils/common/navigator_extension.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  List<DrawerItemModel> getHelpScreenItemList({
    required BuildContext context
  }) =>
      <DrawerItemModel>[
        DrawerItemModel(
          title: "Get Started",
          imagePath: AppImagesPath.appHome,
          onTap: () {
            // if (!kDebugMode) return;

          },
        ),
          DrawerItemModel(
            title: "Help Topics",
            imagePath: AppImagesPath.appAdvertisements,
            onTap: () {
              // if (!kDebugMode) return;
            },
          )
        ,
          DrawerItemModel(
            title: "FAQ’s",
            imagePath: AppImagesPath.appScreens,
            onTap: () {
              // if (!kDebugMode) return;
            },
          ),
        DrawerItemModel(
          title: "Report a problem",
          imagePath: AppImagesPath.appDashboard,
          onTap: () {
            // if (!kDebugMode) return;
          },
        ),
          DrawerItemModel(
            title: "Privacy and Payments",
            imagePath: AppImagesPath.appPayments,
            onTap: () {
              // if (!kDebugMode) return;
            },
          )
        ,
          DrawerItemModel(
            title: "Terms and Condition",
            imagePath: AppImagesPath.appPayments,
            onTap: () {
              // if (!kDebugMode) return;
            },
          ),
        DrawerItemModel(
          title: "About Us",
          imagePath: AppImagesPath.appProfile,
          onTap: () {
            // if (!kDebugMode) return;
          },
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldStateKey,
      backgroundColor:
          userIsAdvertiser ? AppColors.babyOrange : AppColors.babyBlue,
      appBar: DashboardAppBar(
        showHelpScreen: false,
        scaffoldStateKey: scaffoldStateKey,
      ),
      drawer: DashboardDrawer(
        scaffoldStateKey: scaffoldStateKey,
      ),
      body: Container(
        width: AppConfig.width,
        height: AppConfig.height,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            )),
        child: Column(
          children: [
            Container(
              height: 5.h,
              width: 36.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ).paddingOnly(bottom: 10.h),
            Row(
              children: [
                AppText(
                  "Hi, How can we help you?",
                  color: AppColors.oceanBlue,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ).paddingOnly(bottom: 10.h),
            AppTextFormField(
              borderRadius: 70.r,
              borderColor: AppColors.greyColor,
              contentPadding: EdgeInsets.all(10.w),
              prefixIcon: Icon(Icons.search),
              hintText: "Search",
            ).paddingOnly(bottom: 30.h),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount: getHelpScreenItemList(context: context).length,
                itemBuilder: (context, index) {
                  final item = getHelpScreenItemList(context: context)[index];
                  return AppInkWell(
                    onTap: item.onTap,
                    child: Row(
                      children: [
                        // AppCommonImage(
                        //   width: 20.h,
                        //   height: 20.h,
                        //   imagePath: item.imagePath,
                        // ).paddingOnly(right: 10.w),
                        AppText(item.title)
                      ],
                    ),
                  ).paddingSymmetric(vertical: 10.h);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

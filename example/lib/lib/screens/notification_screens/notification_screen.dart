import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/screens/dashboard_screen/dashboard.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldStateKey,
      backgroundColor:
          userIsAdvertiser ? AppColors.babyOrange : AppColors.babyBlue,
      appBar: DashboardAppBar(
        showNotification: false,
        scaffoldStateKey: scaffoldStateKey,
      ),
      drawer: DashboardDrawer(
        scaffoldStateKey: scaffoldStateKey,
      ),
      body: Container(
        width: AppConfig.width,
        height: AppConfig.height,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ).paddingOnly(bottom: 10.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return AppInkWell(
                    child: Card(
                      color: (index % 2 == 0)
                          ? AppColors.babyOrange
                          : AppColors.babyBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "No Screens Found",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          AppText(
                            "We are sorry to inform you! Screens are not available in New York , Try changing the Location.",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder?>((states) {
                                    return RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r));
                                    return null;
                                  }),
                                  padding: MaterialStateProperty.resolveWith<
                                      EdgeInsetsGeometry?>((states) {
                                    return EdgeInsets.all(5.w);
                                  }),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if ((index % 2 == 0)) {
                                        return AppColors.primaryColor;
                                      } else {
                                        return AppColors.secondaryColor;
                                      }
                                    },
                                  ),
                                ),
                                child: AppText(
                                    (index % 2 == 0) ? "Change" : "View"),
                              ),
                              Spacer(),
                              AppText(
                                notificationFormatDate(DateTime.now()),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 10.sp,
                              ),
                            ],
                          )
                        ],
                      ).paddingSymmetric(vertical: 10.w, horizontal: 10.w),
                    ),
                  ).paddingSymmetric(vertical: 2.h);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

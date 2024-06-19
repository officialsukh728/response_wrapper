import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/business_logics/blocs/auth_blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/profile_bloc/profile_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/profile_model.dart';
import 'package:sample/screens/auth_screens/auth_screen.dart';
import 'package:sample/screens/dashboard_screen/dashboard.dart';
import 'package:sample/utils/assets/app_image_path.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_bar/common_app_bar.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_common_image.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/app_textField.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/common/photo_view_zoom.dart';
import 'package:sample/utils/common/pull_to_refresh_widget.dart';
import 'package:sample/utils/common/validators.dart';

part 'edit_profile_screen.dart';
part 'profile_helper.dart';
part 'profile_image_widget.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileModel profileModel;

  ProfileScreen({super.key, required this.profileModel});

  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  final list = [

  ];

  @override
  Widget build(BuildContext context) {
    return PullToRefreshWidget(
      onRefresh: () => getProfileData(context),
      child: Scaffold(
        key: scaffoldStateKey,
        appBar: DashboardAppBar(
          scaffoldStateKey: scaffoldStateKey,
        ),
        drawer: DashboardDrawer(
          scaffoldStateKey: scaffoldStateKey,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is! ProfileLoaded) {
              return Drawer(
                child: getCustomLoading(),
              );
            }
            final profileModel = state.profileModel;
            return ListView(
              children: [
                SizedBox(
                  height: kToolbarHeight.h,
                  child: const AppBarCommonContent(
                    leading: false,
                    title: "Profile",
                  ),
                ),
                // AppCommonImage(
                //   fit: BoxFit.cover,
                //   shape: BoxShape.circle,
                //   border: Border.all(
                //     color: AppColors.black,
                //     width: 1.w,
                //   ),
                //   imagePath: dummyUserImageLink,
                //   width: 152.h,
                //   height: 152.h,
                //   onTap: () => context.push(PhotoVideoViewZoom(urls: [dummyUserImageLink])),
                // ),
                ProfileImageWidget(
                  name: profileModel.userData?.name,
                  imageUrl: profileModel.userData?.photo,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      (profileModel.userData?.name ?? "")
                          .toCapitalizeEveryFirstLetter(),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      profileModel.userData?.userRole ?? "",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ).paddingOnly(bottom: 10.h),
                SizedBox(
                  height: 220.h,
                  child: GridView.builder(
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 100.h,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GridTile(
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: ShapeDecoration(
                            color: list[index].color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              AppText(
                                "${list[index].value}",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                              AppText(
                                list[index].title,
                                fontSize: 12.sp,
                                maxLines: 1,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ).paddingAll(5.w),
                      );
                    },
                  ),
                ).paddingSymmetric(horizontal: 30.w),
                for (var item in getProfileItemList(
                    context: context, profileModel: profileModel))
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppInkWell(
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
                      ),
                      Divider(),
                    ],
                  ).paddingSymmetric(vertical: 10.h, horizontal: 20.w)
              ],
            );
          },
        ),
      ),
    );
  }
}

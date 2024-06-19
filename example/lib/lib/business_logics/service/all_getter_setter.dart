import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/repository/auth_repo.dart';
import 'package:sample/business_logics/repository/location_repo.dart';
import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/business_logics/service/dio_services.dart';
import 'package:sample/business_logics/service/prefers_utility.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/assets/app_image_path.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_common_image.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/common/photo_view_zoom.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:sample/utils/theme/app_theme.dart';

/// Default longitude value.
double get getDefaultLongitude => 30.704649;

/// Default latitude value.
double get getDefaultLatitude => 76.717873;

/// Error message for generic errors.
String get someWentWrong => "Some Went Wrong";

/// Method to hide the application's keyboard.
void get hideAppKeyboard => FocusManager.instance.primaryFocus?.unfocus();

/// Default dummy user image link.
String get dummyUserImageLink => "https://via.placeholder.com/132x136";

/// Default dummy user video link.
String get dummyUserVideoLink =>
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
    // "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

/// Http service instance.
HttpService get getHttpService => GetIt.I.get<HttpService>();

/// Location repository instance.
LocationRepo get getLocationRepo => GetIt.I.get<LocationRepo>();

/// Screen repository instance.

/// Authentication repository instance.
AuthRepo get getAuthRepo => GetIt.I.get<AuthRepo>();

/// Boolean indicating whether the application is in API mode.
bool get noApiMode => true;

/// User role getter.
String? get getUserRole =>
    LocalStorage.instance.getString(PrefConstants.userRole);

/// Boolean indicating whether the user is an advertiser.
bool get userIsAdvertiser =>
    LocalStorage.instance.getString(PrefConstants.userRole) ==
    RegisterRoleConst.ADVERTISER.name.toString();

/// Get the login user's ID.
String? get getLoginUserId =>
    LocalStorage.instance.getString(PrefConstants.loginUserId);

/// Represents an empty [FormData] object with no fields or files.
FormData get emptyFormData => FormData.fromMap({});

/// Method to share content using the Share plugin.
Future<void> sharePlus({String? url}) async =>
    await Share.share(url ?? "A2A", subject: 'A2A');

/// Generate a referral link based on the user's email.
String generateReferralLink(String email) {
  String referralCode = email.hashCode.toString();
  String referralLinkFormat = "${AppEndPoint.baseUrl}?ref=";
  String referralLink = referralLinkFormat + referralCode;
  infoLog(referralLink, fun: "referralLink");
  return referralLink;
}

/// Returns a linear gradient with custom colors for UI elements.
LinearGradient get getLinearGradient => const LinearGradient(
      end: Alignment(1.00, 0.00),
      begin: Alignment(-1, 0),
      colors: [Color(0xFF269BFF), Color(0xFF8054FF)],
    );

/// Returns the base color for the shimmer effect.
/// If the base color is not available, it defaults to [Colors.grey].
Color get baseColorShimmer => Colors.grey[300] ?? Colors.grey;

/// Returns the highlight color for the shimmer effect.
/// If the highlight color is not available, it defaults to [Colors.grey].
Color get highlightColorShimmer => Colors.grey[100] ?? Colors.grey;

/// Retrieves the Firebase Cloud Messaging (FCM) token asynchronously.
/// Returns the FCM token as a [String].
Future<String> getFcmToken() async {
  try {
    // Attempt to retrieve the FCM token
    return await FirebaseMessaging.instance.getToken() ?? "";
  } catch (e, s) {
    // Catch any errors that occur during token retrieval and log them
    errorLog(e.toString() + s.toString(), fun: "getFcm");
    // Return an empty string if an error occurs
    return "";
  }
}

/// Format a number string with commas.
String getNumberFormat(String? value) {
  try {
    int number = int.tryParse(value ?? "0") ?? 0;
    return NumberFormat('#,##0').format(number);
  } catch (e, t) {
    errorLog(e.toString() + t.toString(), fun: "getNumberFormat");
    return value ?? "0";
  }
}

/// Scroll to the top of the page.
void scrollToTop({
  double? position,
  Duration? duration,
  required ScrollController scrollController,
}) {
  scrollController.animateTo(
    position != null
        ? (AppConfig.height * position)
        : scrollController.position.maxScrollExtent,
    duration: duration ?? const Duration(seconds: 1),
    curve: Curves.fastOutSlowIn,
  );
}

/// Merge two FormData instances.
FormData mergeFormData({
  required FormData formData1,
  required FormData formData2,
}) {
  FormData combinedFormData = FormData();

  /// Merge fields
  combinedFormData.fields.addAll(formData1.fields);
  combinedFormData.fields.addAll(formData2.fields);

  /// Merge files
  combinedFormData.files.addAll(formData1.files);
  combinedFormData.files.addAll(formData2.files);

  return combinedFormData;
}

/// Show a common dialog.
Future<Object?> appCommonDialog({
  required BuildContext context,
  required String title,
  required String content,
  Widget? contentWidget,
  String? buttonTitle,
  String? closeTitle,
  void Function()? onTap,
}) {
  return appCommonDialogBuilder(
    context: context,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppCommonImage(
                width: 20.h,
                height: 20.h,
                imagePath: AppImagesPath.appLogo,
              ).paddingOnly(right: 5.w),
              Expanded(
                child: AppText(
                  "sample",
                  fontSize: 18.sp,
                  fontFamily: AppFonts.righteous,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppInkWell(
                onTap: () => context.pop(),
                child: const Icon(Icons.close),
              ),
            ],
          ).paddingOnly(bottom: 10.h),
          AppText(
            title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ).paddingOnly(bottom: 5.h),
          if(contentWidget!=null)
            contentWidget.paddingOnly(bottom: 20.h)
          else
          AppText(
            content,
            maxLines: 10,
            fontSize: 12.sp,
            color: AppColors.oceanBlue,
          ).paddingOnly(bottom: 20.h),
          if (buttonTitle != null&&closeTitle != null)
            Row(
              children: [
                Expanded(
                  child: AppCommonButton(
                    height: 50.h,
                    context: context,
                    title: buttonTitle,
                    backGroundColor: userIsAdvertiser?AppColors.secondaryColor:AppColors.primaryColor,
                    width: (AppConfig.width*0.4) -20.w,
                    borderRadius: 7.r,
                    onTap: () {
                      context.pop();
                      if(onTap!=null)onTap!();
                    },
                  ),
                ),
                5.widthBox,
                Expanded(
                  child: AppCommonButton(
                    height: 50.h,
                    context: context,
                    title: closeTitle,
                    backGroundColor: !userIsAdvertiser?AppColors.secondaryColor:AppColors.primaryColor,
                    width: (AppConfig.width*0.4) -20.w,
                    borderRadius: 7.r,
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ).paddingOnly(bottom: 10.h)
          else if (buttonTitle != null)
            AppCommonButton(
              height: 50.h,
              context: context,
              title: buttonTitle,
              width: AppConfig.width -80.w,
              backGroundColor: userIsAdvertiser?AppColors.secondaryColor:AppColors.primaryColor,
              onTap: () {
                    context.pop();
                    if(onTap!=null)onTap!();
              },
            ).paddingOnly(bottom: 10.h),
        ],
      ).paddingAll(20.w),
    ),
  );
}

/// Build a common dialog.
Future<Object?> appCommonDialogBuilder({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool barrierDismissible = true,
  Duration transitionDuration = const Duration(milliseconds: 100),
}) async {
  return await showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (c, animation, secondaryAnimation) {
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return SafeArea(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0), // from bottom
            end: const Offset(0.0, 0.0), // to top
          ).animate(curvedAnimation),
          child: builder(c),
        ).paddingSymmetric(
          vertical: 10.h,
        ),
      );
    },
  );
}

/// HTML content for a no data found message.
String get noDataFoundHtml => '''
                          <!DOCTYPE html>
<html>
<head>
    <title>No Data Found</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        div {
            text-align: center;
        }
    </style>
</head>
<body>
    <div>
        <h1>No Data Found</h1>
        <p>There is no data available at the moment.</p>
    </div>
</body>
</html>

                          ''';

Widget buildAvatarContainer({
  required String? image,
  required String? name,
  required BuildContext context,
  BoxShape shape=BoxShape.circle,
  double? width=50,
  double? height=50,
  double? fontSize=25,
}) {
  if ((image == null ||image.isEmpty)) {
    return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appArrayColor(
                  firstCharacter: splitNameOnlyOneWord(name: name??"T"),
                ),
              ),
            ),
            Center(
              child: Text(
            splitNameOnlyOneWord(name: name??"T"),
                style: TextStyle(color: Colors.white, fontSize: fontSize,),
              ),
            ),
          ],
        );
  } else {
    return AppInkWell(
      onTap: () =>                 context.push(PhotoVideoViewZoom(
        urls: [image!],
      )),
      child: AppCommonImage(imagePath: image,
      shape: shape,
      height: height,width: width,
      fit: BoxFit.fill,
      border: Border.all(color: Colors.black),
        ),
    );
  }
}
String splitNameOnlyOneWord({required String name}) {
  if (name.isNotEmpty) return name[0].toCapitalizeFirstWordOnly();
  return "T";
}
Color? appArrayColor({required String firstCharacter,})
{
  Map<String, Color> colorsMap = HashMap();

  colorsMap.addAll(
    {"A": const Color(0xff00FFFF),
      "B": const Color(0xff0000FF),
      "C": const Color(0xffFF8C00),
      "D": const Color(0xffFFD700),
      "E": const Color(0xff008000),
      "F": const Color(0xffFF00FF),
      "G": const Color(0xffDDA0DD),
      "H": const Color(0xffFF69B4),
      "I": const Color(0xff4B0082),
      "J": const Color(0xff00A86B),
      "K": const Color(0xffF0E68C),
      "L": const Color(0xff59a4ea),
      //    "L": const Color(0xffE6E6FA),
      "M": const Color(0xff000080),
      "N": const Color(0xffE0115F),
      "0": const Color(0xff808000),
      "P": const Color(0xff800080),
      "Q": const Color(0xffda7041),
      //    "Q": const Color(0xffE0D0C6),
      "R": const Color(0xffFF0000),
      "S": const Color(0xff93da63),
      //    "S": const Color(0xffC0C0C0),
      "T": const Color(0xff008080),
      "U": const Color(0xff808000),
      "V": const Color(0xffD2691E),
      "W": const Color(0xffEE82EE),
      "X": const Color(0xff738678),
      "Y": const Color(0xffFFFF00),
      "Z": const Color(0xff000000)},
  );// Is a HashMap

  ///check if the map contains user first latter
  if(firstCharacter.isNotEmpty && colorsMap.containsKey(firstCharacter[0].toUpperCase()))
  {
    Color color = colorsMap[firstCharacter[0].toUpperCase()]!;
    return color;
  }

  ///else pass default color
  return AppColors.primaryColor;
}
String formatTimeOfDay(TimeOfDay timeOfDay) {
  try {
    final dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm:ss').format(dateTime);
  } catch (e, s) {
    errorLog(e.toString() + s.toString(), fun: "format Time Date");
    return timeOfDay.format(globalBuildContext);
  }
}

String scheduledFormatDate(DateTime dateTime, {required String title}) {
  try {
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return "$title on $formattedDate";
  } catch (e, s) {
    errorLog(e.toString() + s.toString(), fun: "format$title Date");
    return "$title on ${dateTime.toIso8601String()}";
  }
}
String notificationFormatDate(DateTime dateTime) {
  try {
    // Format day
    String day = dateTime.day.toString();

    // Format month abbreviation
    List<String> months = [
      '', // Placeholder for indexing from 1
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    String month = months[dateTime.month];

    // Format hour
    String hour = (dateTime.hour % 12).toString();

    // Format minute
    String minute = dateTime.minute.toString().padLeft(2, '0');

    // Format AM/PM marker
    String amPm = dateTime.hour < 12 ? 'am' : 'pm';

    // Combine all parts
    return '$day $month at $hour:$minute $amPm';

    return DateFormat('dd MMM "at" HH:mm a').format(dateTime);
  } catch (e, s) {
    errorLog(e.toString() + s.toString(), fun: "format Date");
    return dateTime.toIso8601String();
  }
}
String formatDate(DateTime dateTime) {
  try {
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  } catch (e, s) {
    errorLog(e.toString() + s.toString(), fun: "format Date");
    return dateTime.toIso8601String();
  }
}
List<String> generateMonthListWithYear() {
  // List of month names
  final List<String> months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  // Get current month and year
  final now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;

  // Generate the list of months
  final List<String> monthList = [];

  // Iterate over previous months starting from the current month
  for (int i = currentMonth - 1; i >= 0; i--) {
    monthList.add('${months[i]} $currentYear');
  }

  // Iterate over months of the previous years
  for (int i = months.length - 1; i > currentMonth - 1; i--) {
    monthList.add('${months[i]} ${currentYear - 1}');
  }

  return monthList;
}


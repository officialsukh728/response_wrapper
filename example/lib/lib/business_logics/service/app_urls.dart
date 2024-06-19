import 'dart:io';

class AppEndPoint {
  static const String baseUrl = 'https://trillboard-api.netscapelabs.com/v1/';
  static String deviceType = Platform.isAndroid == true ? "android" : "ios";
  static const String login = 'user/login';
  static const String googleLogin = 'user/login-with-google';
  static const String appleLogin = 'user/login-with-apple';
  static const String facebookLogin = 'user/login-with-facebook';
  static const String register = 'user/signUp';
  static const String logout = 'user/logout';
  static const String getUserProfile = 'user/get-user-profile';
  static const String createNewPassword = 'user/reset-password';
  static const String forgot = 'user/forgot-password';
  static const String forgotPasswordVerify = 'user/verify-otp';
  static const String deleteAccount = 'user/delete-account';
  static const String editProfile = 'user/edit-user-profile';
  /// pending
  static const String uploadImage = 'customer/image-verify';
  static const String termsOfUse = 'configuration/terms_of_use';
  static const String privacyPolicy = 'configuration/privacy_policy';
  static const String aboutUs = 'configuration/about_us';
  static const String faq = 'faq';
  static const String sendHelpAndSupport = 'customer/send-help_support';

  /// Earner User
  static const String getEarnerDashboard = 'earner/dashboard-data';
  static const String addNewScreen = 'earner/create-screen';
  static const String getAllScreen = 'earner/screens-list';
  static const String editTrillBoard = 'earner/edit-screen';
  static const String withdrawAmount = 'earner/withdraw-payment';
  static const String deleteTrillBoard = 'earner/delete-screen';
  static const String getAllEarnerAdvertisement = 'earner/advertisement-list';
  static const String getEarningList = 'earner/advertisement-list';
  static const String updateUserLocation = 'earner/add-loaction';

  /// Advertiser User
  static const String getAdvertiserDashboard = 'advertiser/dashboard-data';
  static const String addAdvertisement = 'advertiser/create-advertisement';
  static const String getAllAdvertisement = 'advertiser/advertisement-list';
  static const String getPaymentList = 'advertiser/payment-list';
  static const String getScreenListMarker = 'advertiser/screen-list';
  static const String getHeatmapLocation = 'advertiser/crowd-density';
  static const String deleteAdvertisement = 'advertiser/delete-advertisement';
  static const String allAdvertisementLocation = 'advertiser/add-location-advertisement';
  static const String alotScreen = 'advertiser/alot-screen';
  static const String createPaymentIntent = 'user/payment-intent';

}

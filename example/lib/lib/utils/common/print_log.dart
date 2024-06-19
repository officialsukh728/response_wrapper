import 'dart:io';


// Todo: must be false on last app release Bundle time
/// we can see app log using this cmd in terminal
/// For Android
/// /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/// brew install android-platform-tools
/// adb version
/// adb logcat | grep -E 'http|https'
/// For Ios
/// /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/// brew install --HEAD libimobiledevice
/// idevicesyslog | grep -E 'http|https'

const customDebugMode = true;

void errorLog(
  dynamic text, {
  dynamic fun = "",
}) {
  if (customDebugMode) {
    if (Platform.isIOS) {
      print("$fun ()=> ${text.toString()}");
    } else {
      print('\x1B[32m${"$fun () => "}\x1B[0m\x1B[31m${text.toString()}\x1B[0m');
    }
  }
}

void printLog(
  dynamic text, {
  dynamic fun = "",
}) {
  if (customDebugMode) {
    if (Platform.isIOS) {
      print("$fun ()=> ${text.toString()}");
    } else {
      print('\x1B[31m${"$fun () => "}\x1B[0m\x1B[32m${text.toString()}\x1B[0m');
    }
  }
}

void infoLog(
  dynamic text, {
  dynamic fun = "",
}) {
  if (customDebugMode) {
    if (Platform.isIOS) {
      print("$fun ()=> ${text.toString()}");
    } else {
      print('\x1B[32m${"$fun () => "}\x1B[0m\x1B[33m${text.toString()}\x1B[0m');
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:sample/utils/common/print_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Opens a year picker dialog to select a year.
Future<String> openYearPicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime? pickedDate = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return YearPickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(DateTime.now().year - 100),
        lastDate: lastDate ?? DateTime(DateTime.now().year + 100),
      );
    },
  );

  if (pickedDate == null) return "";
  return DateFormat('yyyy').format(pickedDate);
}

/// A dialog to pick a year.
class YearPickerDialog extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  YearPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200.h,
        child: YearPicker(
          selectedDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onChanged: (DateTime dateTime) {
            Navigator.of(context).pop(dateTime);
          },
        ),
      ),
    );
  }
}

/// Selects a date range within a specified range.
Future<DateTimeRange?> selectBookingDateRange({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: lastDate,
  );
}

/// Opens a date picker dialog to select a date.
Future<String> openDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    lastDate: lastDate ?? DateTime.now(),
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime.now(),
  );
  if (pickedDate == null) return "";
  return DateFormat('yyyy-MM-dd').format(pickedDate);
}

/// Opens a time picker dialog to select a time.
Future<String?> openTimePicker({
  required BuildContext context,
}) async {
  try {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (pickedTime != null) {
      printLog(pickedTime.format(context).toString());
      return convert12To24Hour(pickedTime.format(context));
    }
  } catch (e) {
    errorLog(e);
  }
  return null;
}

/// Checks if a given time is within a specified range.
bool isTimeInRange({
  required String openTime,
  required String closeTime,
}) {
  try {
    DateTime now = DateTime.now();
    DateTime openDateTime = DateTime(now.year, now.month, now.day,
        int.parse(openTime.split(':')[0]), int.parse(openTime.split(':')[1]));
    DateTime closeDateTime = DateTime(now.year, now.month, now.day,
        int.parse(closeTime.split(':')[0]), int.parse(closeTime.split(':')[1]));
    return (openDateTime).isAfter(closeDateTime);
  } catch (e) {
    errorLog(e);
    return false;
  }
}

/// Converts a 12-hour format time to 24-hour format.
String convert12To24Hour(String time12Hour) {
  try {
    final format12Hour =
    (time12Hour.contains("AM") || time12Hour.contains("PM"))
        ? DateFormat("hh:mm a")
        : DateFormat("hh:mm");
    final format24Hour = DateFormat("HH:mm");
    final dateTime = format12Hour.parse(time12Hour);
    return format24Hour.format(dateTime);
  } catch (e) {
    errorLog(e);
    return "";
  }
}

/// Returns a human-readable string representing the time elapsed since the given date.
String getTimeSinceCreation(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return "";
  DateTime createdDate = DateTime.parse(createdAt);
  Duration timeDiff = DateTime.now().difference(createdDate);
  int secondsDiff = timeDiff.inSeconds;
  if (secondsDiff < 60) {
    return "just now";
  } else if (secondsDiff < 3600) {
    int minutesDiff = (secondsDiff / 60).floor();
    return minutesDiff == 1 ? "1 minute ago" : "$minutesDiff minutes ago";
  } else if (secondsDiff < 86400) {
    int hoursDiff = (secondsDiff / 3600).floor();
    return hoursDiff == 1 ? "1 hour ago" : "$hoursDiff hours ago";
  } else if (secondsDiff < 172800) {
    return "Yesterday";
  } else if (secondsDiff < 2592000) {
    int daysDiff = (secondsDiff / 86400).floor();
    return daysDiff == 1 ? "1 day ago" : "$daysDiff days ago";
  } else if (secondsDiff < 31536000) {
    int monthsDiff = (secondsDiff / 2592000).floor();
    return monthsDiff == 1 ? "1 month ago" : "$monthsDiff months ago";
  } else {
    int yearsDiff = (secondsDiff / 31536000).floor();
    return yearsDiff == 1 ? "1 year ago" : "$yearsDiff years ago";
  }
}

/// Returns a string representation of the given date with the format 'dd/MM/yyyy hh:mm a'.
String getPostCreateTime(DateTime? dateTime) {
  if (dateTime == null) return "";
  try {
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  } catch (e, s) {
    return dateTime.toIso8601String();
  }
}

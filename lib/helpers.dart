part of 'response_wrapper.dart';

String trans(BuildContext context, String s) {
  return s;
}

const Color cardBgColor = Color(0xff363636);
const Color colorB58D67 = Color(0xffB58D67);
const Color colorE5D1B2 = Color(0xffE5D1B2);
const Color colorF9EED2 = Color(0xffF9EED2);
const Color colorFFFFFD = Color(0xffFFFFFD);

double topHeight = 0.10;
const Color primary = Color(0xFF1E54BA);
const Color secondary = Color(0xFF384199);
Color black = Colors.black;
Color white = Colors.white;

Color get grey => Colors.grey;

MaterialColor get deepOrange => Colors.deepOrange;

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

SizedBox yHeight(double height) {
  return SizedBox(
    height: height,
  );
}

SizedBox xWidth(double width) {
  return SizedBox(
    width: width,
  );
}

/// Navigator functions
void pushTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

void back(BuildContext context) {
  Navigator.pop(context);
}

/// field decoration
InputDecoration fieldDeco({
  String? labelText,
  TextStyle? labelStyle,
  String? hintText,
  bool? showSuffixIcon,
  Widget? suffix,
  bool? showPrefixIcon,
  Widget? prefix,
}) {
  return InputDecoration(
    prefixIcon: (showPrefixIcon ?? false) ? prefix : null,
    focusedBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: primary)),
    labelStyle:
        labelStyle ?? const TextStyle(color: Colors.black38, fontSize: 21),
    suffixIcon: (showSuffixIcon ?? false) ? suffix : null,
    suffixIconColor: primary,
    labelText: labelText,
    hintText: hintText,
  );
}



Widget customLoader({
  double height = 25,
  double width = 25,
  Color color = Colors.black,
  double? value,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: CircularProgressIndicator(
      color: color,
      value: value,
    ),
  );
}

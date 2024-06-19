import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<String> onChanged;
  final bool useFormat;
  final bool reverse;
  final int step;

  NumberPicker({
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.useFormat = true,
    this.reverse = false,
    this.step = 1,
  });

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _selectedValue = 0;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _scrollController = FixedExtentScrollController(
      initialItem: (widget.value - widget.minValue) ~/ widget.step,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: BlocBuilder<NumberPickerChangedToggleBloc, int>(
        builder: (_, __) {
          return CupertinoPicker.builder(
            scrollController: _scrollController,
            itemExtent: 40.h,
            useMagnifier: true,
            onSelectedItemChanged: (index) {
              final value = widget.minValue + index * widget.step;
              _selectedValue = value;
              final response =
              widget.useFormat ? getNumberFormat(value.toString()) : value
                  .toString();
              widget.onChanged(response);
              HapticFeedback.selectionClick();
              context.read<NumberPickerChangedToggleBloc>().rebuild();
            },
            childCount: (widget.maxValue - widget.minValue) ~/ widget.step + 1,
            itemBuilder: (context, index) {
              final value = /*widget.reverse
                  ? widget.maxValue - index * widget.step
                  : */widget.minValue + index * widget.step;
              final formattedValue =
              widget.useFormat ? getNumberFormat(value.toString()) : value
                  .toString();
              return Center(
                child: Text(
                  formattedValue,
                  style: TextStyle(
                      fontSize: 17.sp
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String getNumberFormat(String value) {
  try {
    final number = int.tryParse(value) ?? 0;
    return NumberFormat('#,##0').format(number);
  } catch (e, t) {
    errorLog(e.toString() + t.toString(), fun: "getNumberFormat");
    return value;
  }
}

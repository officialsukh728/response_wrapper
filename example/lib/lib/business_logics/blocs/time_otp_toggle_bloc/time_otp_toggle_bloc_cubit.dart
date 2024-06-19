import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'time_otp_toggle_bloc_state.dart';

class TimeOtpToggleCubit extends Cubit<TimeOtpToggleState> {
  TimeOtpToggleCubit() : super(const TimeOtpToggleState());
  Timer? timer;

  void startTime() {
    if (timer != null) {
      timer?.cancel();
      timer == null;
      emit(const TimeOtpToggleState());
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.time == 1) {
        emit(state.copyWith(
          time: 0,
          resendAvailable: true,
        ));
        timer.cancel();
      }else {
        emit(state.copyWith(
        time: state.time - 1,
      ));
      }
    });
  }
}

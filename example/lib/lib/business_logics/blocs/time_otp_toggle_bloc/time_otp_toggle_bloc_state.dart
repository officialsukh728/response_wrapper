part of 'time_otp_toggle_bloc_cubit.dart';

class TimeOtpToggleState extends Equatable {
  final int time;
  final bool resendAvailable;

  const TimeOtpToggleState({
    this.time = 30,
    this.resendAvailable = false,
  });

  TimeOtpToggleState copyWith({
    int? time,
    bool? resendAvailable,
  }) {
    return TimeOtpToggleState(
      time: time ?? this.time,
      resendAvailable: resendAvailable ?? this.resendAvailable,
    );
  }

  @override
  List<Object?> get props => [time, resendAvailable];
}

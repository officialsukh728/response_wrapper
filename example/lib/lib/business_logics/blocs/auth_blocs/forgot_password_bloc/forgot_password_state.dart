part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSendLoading extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordVerifyLoading extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSendSuccess extends ForgotPasswordState {
  final bool listener;
  final CommonAuthModel model;

  const ForgotPasswordSendSuccess({
    required this.listener,
    required this.model,
  });

  @override
  List<Object> get props => [listener, model];
}

class ForgotPasswordVerifySuccess extends ForgotPasswordState {
  final CommonAuthModel model;

  const ForgotPasswordVerifySuccess(this.model);

  @override
  List<Object> get props => [model];
}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final CommonAuthModel model;

  const ForgotPasswordLoaded(this.model);

  @override
  List<Object> get props => [model];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  const ForgotPasswordError(this.error);

  @override
  List<Object> get props => [];
}

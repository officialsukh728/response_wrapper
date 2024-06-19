part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  final CommonAuthModel userModel;

  const LoginLoaded(this.userModel);

  @override
  List<Object> get props => [userModel];
}

class LoginLoadedSuccess extends LoginState {
  final CommonAuthModel model;

  const LoginLoadedSuccess(this.model);

  @override
  List<Object> get props => [model];
}

class LoginError extends LoginState {
  final String error;

  const LoginError(this.error);

  @override
  List<Object> get props => [error];
}

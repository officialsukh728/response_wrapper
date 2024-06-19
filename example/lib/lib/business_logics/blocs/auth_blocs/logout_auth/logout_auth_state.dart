part of 'logout_auth_bloc.dart';

abstract class LogoutDeleteAuthState extends Equatable {
  const LogoutDeleteAuthState();
}

class LogoutAuthInitial extends LogoutDeleteAuthState {
  @override
  List<Object> get props => [];
}

class LogoutAuthLoading extends LogoutDeleteAuthState {
  @override
  List<Object> get props => [];
}

class DeleteAuthLoading extends LogoutDeleteAuthState {
  @override
  List<Object> get props => [];
}

class LogoutDeleteAuthLoaded extends LogoutDeleteAuthState {
  final CommonAuthModel logoutModel;

  const LogoutDeleteAuthLoaded(this.logoutModel);
  @override
  List<Object> get props => [logoutModel];
}

class LogoutAuthSuccess extends LogoutDeleteAuthState {
  final CommonAuthModel logoutModel;

  const LogoutAuthSuccess(this.logoutModel);
  @override
  List<Object> get props => [logoutModel];
}

class DeleteAuthSuccess extends LogoutDeleteAuthState {
  final CommonAuthModel logoutModel;

  const DeleteAuthSuccess(this.logoutModel);
  @override
  List<Object> get props => [logoutModel];
}

class LogoutDeleteAuthError extends LogoutDeleteAuthState {
  final String error;

  const LogoutDeleteAuthError(this.error);
  @override
  List<Object> get props => [error];
}

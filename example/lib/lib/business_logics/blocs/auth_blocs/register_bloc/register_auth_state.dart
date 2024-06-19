part of 'register_auth_bloc.dart';

abstract class RegisterAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterAuthInitial extends RegisterAuthState {
  @override
  List<Object> get props => [];
}

class ResisterAuthLoading extends RegisterAuthState {
  @override
  List<Object> get props => [];
}

class ResisterAuthLoaded extends RegisterAuthState {
  final FormData formData;
  final CommonAuthModel registerModel;

  ResisterAuthLoaded({
    required this.registerModel,
    required this.formData,
  });

  @override
  List<Object> get props => [registerModel, formData];
}

class ResisterAuthLoadedSuccess extends RegisterAuthState {
  final bool listener;
  final CommonAuthModel registerModel;

  ResisterAuthLoadedSuccess(
    this.registerModel, {
    this.listener = true,
  });

  @override
  List<Object> get props => [registerModel, listener];
}

class ResisterAuthError extends RegisterAuthState {
  final String error;
  ResisterAuthError(this.error);
  @override
  List<Object> get props => [error];
}

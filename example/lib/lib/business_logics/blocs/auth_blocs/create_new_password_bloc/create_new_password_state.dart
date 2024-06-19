part of 'create_new_password_bloc.dart';

abstract class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState();
}

class CreateNewPasswordInitial extends CreateNewPasswordState {
  @override
  List<Object> get props => [];
}

class CreateNewPasswordLoading extends CreateNewPasswordState {
  @override
  List<Object> get props => [];
}

class CreateNewPasswordSuccess extends CreateNewPasswordState {
  final CommonAuthModel model;

  const CreateNewPasswordSuccess(this.model);
  @override
  List<Object> get props => [model];
}

class CreateNewPasswordLoaded extends CreateNewPasswordState {
  final CommonAuthModel model;

  const CreateNewPasswordLoaded(this.model);
  @override
  List<Object> get props => [model];
}

class CreateNewPasswordError extends CreateNewPasswordState {
  final String error;

  const CreateNewPasswordError(this.error);
  @override
  List<Object> get props => [error];
}

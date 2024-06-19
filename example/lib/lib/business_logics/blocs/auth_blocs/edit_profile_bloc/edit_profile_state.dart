part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
}

class EditProfileInitial extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileLoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileOnRadioLoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileOnDobLoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileOnImageLoading extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileLoaded extends EditProfileState {
  final bool listener;
  final CommonAuthModel registerModel;

  EditProfileLoaded(
      this.registerModel, {
        this.listener = true,
      });

  @override
  List<Object> get props => [registerModel, listener];
}

class EditProfileLoadedSuccess extends EditProfileState {
  final bool listener;
  final CommonAuthModel registerModel;

  EditProfileLoadedSuccess(
      this.registerModel, {
        this.listener = true,
      });

  @override
  List<Object> get props => [registerModel, listener];
}

class EditProfileError extends EditProfileState {
  final String error;
  EditProfileError(this.error);
  @override
  List<Object> get props => [error];
}
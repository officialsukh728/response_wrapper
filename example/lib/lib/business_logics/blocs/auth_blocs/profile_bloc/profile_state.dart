part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;

  const ProfileLoaded(this.profileModel);

  @override
  List<Object> get props => [profileModel];
}

class ProfileLoadedSuccess extends ProfileState {
  final ProfileModel profileModel;

  const ProfileLoadedSuccess(this.profileModel);

  @override
  List<Object> get props => [profileModel];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

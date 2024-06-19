part of 'social_login_bloc.dart';

abstract class SocialLoginState extends Equatable {
  const SocialLoginState();
}

class SocialLoginInitial extends SocialLoginState {
  @override
  List<Object> get props => [];
}

class SocialGoogleLoginLoading extends SocialLoginState {
  @override
  List<Object> get props => [];
}

class SocialFacebookLoginLoading extends SocialLoginState {
  @override
  List<Object> get props => [];
}

class SocialAppleLoginLoading extends SocialLoginState {
  @override
  List<Object> get props => [];
}

class SocialLoginLoaded extends SocialLoginState {
  final CommonAuthModel model;

  const SocialLoginLoaded(this.model);
  @override
  List<Object> get props => [model];
}

class SocialLoginSuccess extends SocialLoginState {
  final CommonAuthModel model;

  const SocialLoginSuccess(this.model);
  @override
  List<Object> get props => [model];
}

class SocialLoginError extends SocialLoginState {
  final String error;

  const SocialLoginError(this.error);
  @override
  List<Object> get props => [error];
}

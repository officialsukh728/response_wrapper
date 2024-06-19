part of 'upload_image_bloc.dart';

abstract class UploadImageState extends Equatable {
  const UploadImageState();
}

class UploadImageInitial extends UploadImageState {
  @override
  List<Object> get props => [];
}

class UploadImageLoading extends UploadImageState {
  @override
  List<Object> get props => [];
}

class UploadImageSuccess extends UploadImageState {
  final CommonAuthModel model;

  UploadImageSuccess(this.model);
  @override
  List<Object> get props => [model];
}

class UploadImageLoaded extends UploadImageState {
  final CommonAuthModel model;

  UploadImageLoaded(this.model);
  @override
  List<Object> get props => [model];
}

class UploadImageError extends UploadImageState {
  final String error;

  UploadImageError(this.error);
  @override
  List<Object> get props => [error];
}

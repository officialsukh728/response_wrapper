part of 'update_location_bloc.dart';

abstract class UpdateLocationState extends Equatable {
  const UpdateLocationState();
}

class UpdateLocationInitial extends UpdateLocationState {
  @override
  List<Object> get props => [];
}

class UpdateLocationLoading extends UpdateLocationState {
  @override
  List<Object> get props => [];
}

class UpdateLocationLoaded extends UpdateLocationState {
  final CommonAuthModel model;

  const UpdateLocationLoaded(this.model);
  @override
  List<Object> get props => [model];
}

class UpdateLocationSuccess extends UpdateLocationState {
  final CommonAuthModel model;

  const UpdateLocationSuccess(this.model);
  @override
  List<Object> get props => [model];
}

class UpdateLocationError extends UpdateLocationState {
  final String error;

  const UpdateLocationError(this.error);
  @override
  List<Object> get props => [error];
}

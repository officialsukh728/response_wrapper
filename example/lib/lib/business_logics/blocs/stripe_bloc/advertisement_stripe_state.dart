part of 'advertisement_stripe_bloc.dart';

abstract class StripeState extends Equatable {
  const StripeState();
}

class StripeInitial extends StripeState {
  @override
  List<Object> get props => [];
}

class StripeLoading extends StripeState {
  @override
  List<Object> get props => [];
}

class StripeLoaded extends StripeState {
  final PaymentSheetPaymentOption? paymentOption;

  StripeLoaded(this.paymentOption);
  @override
  List<Object?> get props => [paymentOption];
}

class StripeSuccess extends StripeState {
  final String success;
 final dynamic paymentIntentData;

  StripeSuccess({required this.success, required this.paymentIntentData});

  @override
  List<Object> get props => [success,paymentIntentData];
}

class StripeError extends StripeState {
  final String error;

  StripeError(this.error);
  @override
  List<Object> get props => [error];
}

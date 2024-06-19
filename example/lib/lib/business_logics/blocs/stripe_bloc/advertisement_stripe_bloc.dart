import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:equatable/equatable.dart';
import 'package:sample/business_logics/service/dio_services.dart';
import 'package:sample/business_logics/service/injector.dart';
import 'package:sample/utils/common/print_log.dart';

part 'advertisement_stripe_state.dart';

class StripeBloc extends Cubit<StripeState> {
  StripeBloc() : super(StripeInitial());
  final googlePay = const PaymentSheetGooglePay(
    merchantCountryCode: 'USA',
    currencyCode: 'USD',
    testEnv: true,
  );
  final applePay= const PaymentSheetApplePay(
    merchantCountryCode: 'USA',
  );


  Future<void> makePayment(String amount) async {
    try {
      emit(StripeLoading());
      final paymentIntentData = await createPaymentIntent(amount: amount,currency:  'USD');
      if(paymentIntentData.isEmpty){
        emit(StripeError("Payment Failed"));
        emit(StripeInitial());
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          googlePay: googlePay,
          // applePay: applePay,
          merchantDisplayName: 'TrillBoard',
        ),
      );
      PaymentSheetPaymentOption? paymentOption;
      if( await displayPaymentSheet()){
        emit(StripeSuccess(success: "Payment Success",
        paymentIntentData: paymentIntentData,));
        emit(StripeLoaded(paymentOption));
        emit(StripeInitial());
      }else{
        emit(StripeError("Payment Failed"));
      }

    } catch (e, s) {
      emit(StripeError(e.toString()));
      emit(StripeInitial());
      errorLog(e.toString() + s.toString(), fun: "getAllScreen");
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException {
      return false;
    } catch (e,s) {
      errorLog(e.toString() + s.toString(), fun: "displayPaymentSheet");
      return false;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final dio = Dio();
      final body = {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
      };
      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppStripeKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
      );
      return response.data;
    }on DioException catch (e) {
      /// Handle DioException and return response
      responseErrorHandler(response: e.response, dioErrorType: e.type);
      return {};
    } catch (e,s) {
      errorLog(e.toString() + s.toString(), fun: "getAllScreen");
      return {};
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/create_new_password_bloc/create_new_password_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/login_bloc/login_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/logout_auth/logout_auth_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/profile_bloc/profile_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/social_login_bloc/social_login_bloc.dart';
import 'package:sample/business_logics/blocs/location_cubit/location_cubit.dart';
import 'package:sample/business_logics/blocs/privacy_policy/privacy_policy_bloc.dart';
import 'package:sample/business_logics/blocs/stripe_bloc/advertisement_stripe_bloc.dart';
import 'package:sample/business_logics/blocs/time_otp_toggle_bloc/time_otp_toggle_bloc_cubit.dart';
import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/business_logics/blocs/upload_image_bloc/upload_image_bloc.dart';

class AppMultiProvider extends StatelessWidget {
  final Widget child;

  const AppMultiProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// api call bloc
        BlocProvider<StripeBloc>(
            create: (_) => StripeBloc()),
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<LogoutDeleteAuthBloc>(
            create: (_) => LogoutDeleteAuthBloc()),
        BlocProvider<ForgotPasswordBloc>(create: (_) => ForgotPasswordBloc()),
        BlocProvider<CreateNewPasswordBloc>(
            create: (_) => CreateNewPasswordBloc()),
        BlocProvider<EditProfileBloc>(create: (_) => EditProfileBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc(), lazy: false),
        BlocProvider<SocialLoginBloc>(create: (_) => SocialLoginBloc()),
        BlocProvider<RegisterAuthBloc>(create: (_) => RegisterAuthBloc()),
        BlocProvider<UploadImageBloc>(create: (_) => UploadImageBloc()),
        BlocProvider<PrivacyPolicyBloc>(create: (_) => PrivacyPolicyBloc()),

        /// toggle bloc
        BlocProvider<OpenDatePickerBloc>(
            create: (_) => OpenDatePickerBloc(), lazy: false),
        BlocProvider<PostImageIndexToggleBloc>(
            create: (_) => PostImageIndexToggleBloc(), lazy: false),
        BlocProvider<LocationCubit>(
            create: (_) => LocationCubit(), lazy: false),
        BlocProvider<ImageVideoSelectionBloc>(
            create: (_) => ImageVideoSelectionBloc(), lazy: false),
        BlocProvider<ShowPasswordToggleBloc>(
            create: (_) => ShowPasswordToggleBloc()),
        BlocProvider<ShowOldPasswordToggleBloc>(
            create: (_) => ShowOldPasswordToggleBloc()),
        BlocProvider<ChooseUserToggleBloc>(
            create: (_) => ChooseUserToggleBloc()),
        BlocProvider<TimeOtpToggleCubit>(create: (_) => TimeOtpToggleCubit()),
        BlocProvider<CheckBoxToggleBloc>(create: (_) => CheckBoxToggleBloc()),
        BlocProvider<TextFieldOnChangedToggleBloc>(
            create: (_) => TextFieldOnChangedToggleBloc()),
        BlocProvider<ProgressOnChangedToggleBloc>(
            create: (_) => ProgressOnChangedToggleBloc()),
        BlocProvider<NumberPickerChangedToggleBloc>(
            create: (_) => NumberPickerChangedToggleBloc()),
        BlocProvider<ShowConPasswordToggleBloc>(
            create: (_) => ShowConPasswordToggleBloc()),
      ],
      child: child,
    );
  }
}

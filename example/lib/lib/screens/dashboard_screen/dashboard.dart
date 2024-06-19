import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/business_logics/blocs/auth_blocs/logout_auth/logout_auth_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/profile_bloc/profile_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/profile_model.dart';
import 'package:sample/screens/auth_screens/auth_screen.dart';
import 'package:sample/screens/help_screens/help_screen.dart';
import 'package:sample/screens/notification_screens/notification_screen.dart';
import 'package:sample/screens/profile_screens/profile_screen.dart';
import 'package:sample/utils/assets/app_image_path.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_bar/common_app_bar.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_common_image.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/app_textField.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/common/pull_to_refresh_widget.dart';
import 'package:sample/utils/common/validators.dart';

part 'app_drawer_helper.dart';
part 'app_drawer_widget.dart';
void getDashboard(BuildContext context) {
  // getProfileData(context);
}

void gotoDashboard(
  BuildContext context, {
  bool isEarnerStripeConnection = false,
}) {
  getDashboard(context);
  if (isEarnerStripeConnection) {
    context.pushAndRemoveUntil(ConnectToStripeScreen());
  } else {
    context.pushAndRemoveUntil(const Dashboard());
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getDashboard(context);
    // FirebaseMessaging.instance.getInitialMessage().asStream().listen((message) {
    //   if (message != null) {
    //     infoLog(message.toMap(), fun: "getInitialMessage");
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PullToRefreshWidget(
      onRefresh: () => getDashboard(context),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldStateKey,
              appBar: DashboardAppBar(
                scaffoldStateKey: scaffoldStateKey,
              ),
              drawer: DashboardDrawer(
                scaffoldStateKey: scaffoldStateKey,
              ),
            );
          },
        ),
      ),
    );
  }
}

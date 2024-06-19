part of 'dashboard.dart';

/// Displays a bottom sheet dialog for deleting or logging out the user's account.
///
/// If [logout] is `true`, the dialog prompts the user to logout the account.
/// Otherwise, it prompts the user to delete the account.
///
/// Requires [BuildContext] to show the dialog.
Future<void> deleteLogoutAccountBottomSheet({
  bool logout = false,
  required BuildContext context,
  required ProfileModel profileModel,
}) async {
  /// Controller for managing text input related to account deletion
  final deleteAccountController = TextEditingController();

  /// GlobalKey for managing the form state
  final formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SingleChildScrollView(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.heightBox,
              AppText(
                logout ? "Logout Account" : "Delete Account",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
              10.heightBox,
              AppText(
                "Are you sure you want to ${logout ? "logout" : "delete"} your account ?",
              ),
              if (!logout && (profileModel.userData?.socialLogin == false))
                BlocBuilder<ShowPasswordToggleBloc, bool>(
                  builder: (context, obscureText) {
                    return Form(
                      key: formKey,
                      child: AppTextFormField(
                        hintText: '********',
                        obscureText: obscureText,
                        controller: deleteAccountController,
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () => context
                              .read<ShowPasswordToggleBloc>()
                              .add(!obscureText),
                          child: Icon(
                            !obscureText
                                ? CupertinoIcons.eye_solid
                                : CupertinoIcons.eye_slash_fill,
                          ),
                        ),
                        validator: (v) => AppValidators.validatePassword(v),
                      ),
                    );
                  },
                ).paddingOnly(top: 20),
              Row(
                children: [
                  Expanded(
                    child: BlocConsumer<LogoutDeleteAuthBloc,
                        LogoutDeleteAuthState>(
                      listener: (context, state) {
                        if(state is LogoutAuthSuccess){
                          context.pushAndRemoveUntil(ChooseUserScreen());
                        }
                        if(state is DeleteAuthSuccess){
                          context.pushAndRemoveUntil(ChooseUserScreen());
                        }
                      },
                      builder: (context, state) {
                        return AppCommonButton(
                          context: context,
                          title: "Yes",
                          width: AppConfig.width * 0.4,
                          backGroundColor: !userIsAdvertiser?AppColors.secondaryColor:AppColors.primaryColor,
                          loading: state is LogoutAuthLoading ||
                              state is DeleteAuthLoading,
                          onTap: () {
                            if (formKey.currentState?.validate() == false) {
                              return;
                            }
                            final bloc = context.read<LogoutDeleteAuthBloc>();
                            logout
                                ? bloc.logout()
                                : showDeleteConfirmationDialog(
                              context: context,
                              onYesPressed: () => bloc.delete(deleteAccountController.text),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  10.xWidth,
                  Expanded(
                    child: AppCommonButton(
                      context: context,
                      title: "No",
                      width: AppConfig.width * 0.4,
                      backGroundColor: userIsAdvertiser?AppColors.secondaryColor:AppColors.primaryColor,
                      onTap: () => context.pop(),
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 20),
            ],
          ).paddingSymmetric(horizontal: 20.h),
        ),
      );
    },
  );
}

/// Displays a confirmation dialog for deleting the user's account.
///
/// Requires [BuildContext] to show the dialog and [onYesPressed] callback function to execute
/// when the user confirms the deletion.
void showDeleteConfirmationDialog({
  required BuildContext context,
  required void Function() onYesPressed,
}) {
  hideAppKeyboard;
  appCommonDialog(
    context: context,
    title: "Confirm Delete",
    buttonTitle: "Yes",
    closeTitle: "No",
    content: "Are you sure that you want to delete your account, as all information will be deleted permanently?",
    onTap:()  {
      Navigator.of(context).pop();
      onYesPressed();
    },
  );
}

part of'profile_screen.dart';

List<DrawerItemModel> getProfileItemList({
  required BuildContext context,
  required ProfileModel profileModel,
}) =>
    <DrawerItemModel>[
      DrawerItemModel(
        title: "View Account Information",
        imagePath: AppImagesPath.appProfile,
        onTap: () {
          // if (!kDebugMode) return;
          context.push(EditProfileScreen(profileModel: profileModel));
        },
      ),
      DrawerItemModel(
        title: "Help",
        imagePath: AppImagesPath.appHelp,
        onTap: () {
          // if (!kDebugMode) return;
        },
      ),
      DrawerItemModel(
        title: "Delete Account",
        imagePath: AppImagesPath.appDelete,
        onTap: () {
          deleteLogoutAccountBottomSheet(
            context: context,
            logout: false,
            profileModel:profileModel,
          );
        },
      ),
    ];

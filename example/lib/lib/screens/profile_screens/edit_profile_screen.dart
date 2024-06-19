part of 'profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profileModel;

  EditProfileScreen({super.key, required this.profileModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserData? userData;
  bool isFormChanged = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController imageFilePathController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getInit();
    context.read<EditProfileBloc>().clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldStateKey,
      appBar: DashboardAppBar(
        scaffoldStateKey: scaffoldStateKey,
      ),
      drawer: DashboardDrawer(
        scaffoldStateKey: scaffoldStateKey,
      ),
      body: AppInkWell(
        onTap: () => hideAppKeyboard,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: kToolbarHeight.h,
                  child: const AppBarCommonContent(
                    title: "Profile",
                  ),
                ),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, profileState) {
                    if (profileState is ProfileLoaded) {
                      getInit();
                    }
                  },
                  builder: (context, profileState) {
                    if (profileState is! ProfileLoaded) {
                      return getCustomLoading();
                    }
                    return BlocBuilder<EditProfileBloc, EditProfileState>(
                      buildWhen: (previous, current) =>
                          previous is EditProfileOnImageLoading ||
                          current is EditProfileOnImageLoading,
                      builder: (context, state) {
                        return ProfileImageWidget(
                          name: widget.profileModel.userData?.name,
                          imageUrl: imageUrlController.text.isEmpty
                              ? null
                              : imageUrlController.text,
                          imagePath: imageFilePathController.text.isEmpty
                              ? null
                              : imageFilePathController.text,
                          onTap: () => context.read<EditProfileBloc>().imageOnTap(
                                context: context,
                                imageController: imageFilePathController,
                              ),
                        );
                      },
                    );
                  },
                ).paddingOnly(bottom: 20.h),
                AppTextFormField(
                  hintText: "Email",
                  readOnly: true,
                  enabled: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    CupertinoIcons.mail_solid,
                    size: 20.h,
                  ),
                  validator: (v) => AppValidators.validateEmail(v),
                ).paddingSymmetric(vertical: 10.h),
                AppTextFormField(
                  controller: fullNameController,
                  hintText: "Name",
                  prefixIcon: Icon(
                    CupertinoIcons.person_fill,
                    size: 20.h,
                  ),
                  validator: AppValidators.validateMessage,
                ).paddingSymmetric(vertical: 10.h),
                AppTextFormField(
                  controller: phoneController,
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    CupertinoIcons.phone,
                    size: 20.h,
                  ),
                ).paddingSymmetric(vertical: 10.h),
                if (widget.profileModel.userData?.userRole ==
                    RegisterRoleConst.EARNER.name&&false)
                  AppTextFormField(
                    controller: locationController,
                    hintText: "Location",
                    prefixIcon: const Icon(CupertinoIcons.location_solid),
                    readOnly: true,
                    validator: AppValidators.validateMessage,
                    onTap: () {
                      context.push(EnterLocationScreen(
                        address: locationController.text,
                        longitude:
                            num.tryParse(longitudeController.text)?.toDouble(),
                        latitude:
                            num.tryParse(latitudeController.text)?.toDouble(),
                      ));
                    },
                  ).paddingSymmetric(vertical: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      "Change Password",
                      color: AppColors.oceanBlue,
                      onTap: () => context.push(ChangePasswordScreen(
                        fromProfile: true,
                        userId: widget.profileModel.userData?.id ?? "",
                      )),
                    )
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileLoaded) return 0.yHeight;
          return BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is EditProfileLoadedSuccess) {
                context.pop();
                getProfileData(context);
              }
            },
            builder: (context, state) {
              return AppCommonButton(
                title: "Save Changes",
                enable: isFormChanged,
                width: AppConfig.width - 40.w,
                loading: state is EditProfileLoading,
                onTap: () async {
                  if (!(formKey.currentState?.validate() ?? false)) return;
                  editProfile(context);
                },
              );
            },
          );
        },
      ).paddingOnly(
        bottom: 15.h,
      ),
    );
  }

  Future<void> editProfile(BuildContext context) async {
    context.read<EditProfileBloc>().editProfile(FormData.fromMap({
          'email': emailController.text,
           "name": fullNameController.text,
          if (phoneController.text.isNotEmpty) "phone": phoneController.text,
          if (imageFilePathController.text.isNotEmpty)
            "photo": await MultipartFile.fromFile(
              imageFilePathController.text,
              filename: imageFilePathController.text.split("/").last,
            ),
        }));
  }

  void getInit() {
    if (context.read<ProfileBloc>().state is! ProfileLoaded) return;
    userData = (context.read<ProfileBloc>().state as ProfileLoaded)
        .profileModel
        .userData;
    if (userData == null) return;
    fullNameController.text = userData?.name ?? "";
    emailController.text = userData?.email ?? "";
    locationController.text =
        userData?.earnerLocation?.address ?? userData?.address ?? "";
    latitudeController.text = "${userData?.earnerLocation?.latitude ?? ""}";
    longitudeController.text = "${userData?.earnerLocation?.longitude ?? ""}";
    phoneController.text = "${userData?.phone ?? ""}";
    imageUrlController.text = userData?.photo ?? "";
    _rebuildUi();
    fullNameController.addListener(_onFormChanged);
    emailController.addListener(_onFormChanged);
    phoneController.addListener(_onFormChanged);
    imageUrlController.addListener(_onFormChanged);
    imageFilePathController.addListener(_onFormChanged);
  }

  /// Listener for text field changes
  void _onFormChanged() {
    bool localIsFormChanged = isFormChanged;
    final bool isValueChanged =
        fullNameController.text != (userData?.name ?? "") ||
            emailController.text != (userData?.email ?? "") ||
            phoneController.text != ("") ||
            imageFilePathController.text.isNotEmpty;
    isFormChanged = isValueChanged;
    if (localIsFormChanged == isFormChanged) return;
    _rebuildUi();
  }

  void _rebuildUi() => context.read<EditProfileBloc>().rebuildUi();
}

part of 'auth_screen.dart';

class ConfirmLocationScreen extends StatefulWidget {
  final LatLng? currentLocation;
  final String? address;
  final Placemark? placemark;

  ConfirmLocationScreen({
    super.key,
   required this.currentLocation,
   required this.address,
   required this.placemark,
  });

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  /// Global key for the location form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateController = TextEditingController();
  final buildingNumberController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final nearbyAddressController = TextEditingController();
  @override
  void initState() {
    addressController.text = widget.address ?? "";
    latitudeController.text = "${widget.currentLocation?.latitude ?? ""}";
    longitudeController.text = "${widget.currentLocation?.longitude ?? ""}";
    zipCodeController.text = widget.placemark?.postalCode ?? "";
    streetController.text = widget.placemark?.street ?? "";
    stateController.text = widget.placemark?.administrativeArea ?? "";
    cityController.text = widget.placemark?.locality ?? "";
    buildingNumberController.text = widget.placemark?.subLocality ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(),
      body: BlocConsumer<UpdateLocationBloc, UpdateLocationState>(
        listener: (context, state) {
          if(state is UpdateLocationSuccess){
            getProfileData(context);
            context.pushAndRemoveUntil(const Dashboard());
          }
        },
        builder: (context, state) {
          final locationBloc = context.read<UpdateLocationBloc>();
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Enter your Location",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ).paddingOnly(bottom: 5.h).paddingSymmetric(horizontal: 20.w),
                  AppText(
                    "Enter your location to let advertisers find you.",
                    fontSize: 12.sp,
                    color: AppColors.oceanBlue,
                  ).paddingOnly(bottom: 10.h).paddingSymmetric(horizontal: 20.w),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: zipCodeController,
                          hintText: "Zip Code (Required)",
                          validator: (p0) =>
                              AppValidators.validateCustom(p0, message: "Zip Code"),
                        ),
                      ),
                      10.widthBox,
                      Expanded(
                        child: AppTextFormField(
                          controller: stateController,
                          hintText: "State (Required)",
                          validator: (p0) =>
                              AppValidators.validateCustom(p0, message: "ZState"),
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 10.h),
                  AppTextFormField(
                    controller: buildingNumberController,
                    hintText: "Building No., Building Name ",
                  ).paddingOnly(bottom: 10.h),
                  AppTextFormField(
                    controller: streetController,
                    hintText: "Street",
                  ).paddingOnly(bottom: 10.h),
                  AppTextFormField(
                    controller: cityController,
                    hintText: "City",
                  ).paddingOnly(bottom: 10.h),
                  if (!locationBloc.showNearWidget)
                    AppText(
                      "+Add Nearby Famous Shop/Mall/Landmark",
                      fontSize: 14.sp,
                      color: AppColors.oceanBlue,
                      onTap: () => locationBloc.toggleWidget(),
                    ).paddingOnly(bottom: 10.h)
                  else
                    AppTextFormField(
                      controller: nearbyAddressController,
                      hintText: "Add Nearby Famous Shop/Mall/Landmark",
                    ).paddingOnly(bottom: 10.h),
                  AppCommonButton(
              context: context,
                    title: "Confirm Location",
                    loading: state is UpdateLocationLoading,
                    backGroundColor: AppColors.secondaryColor,
                    width: AppConfig.width * 0.8,
                    onTap: () {
                      if (formKey.currentState?.validate() == false) return;
                      locationBloc.updateUserLocation(FormData.fromMap({
                        "address":addressController.text,
                        "latitude":latitudeController.text,
                        "longitude":longitudeController.text,
                        "zip_code":zipCodeController.text,
                        "state":stateController.text,
                        "building_number":buildingNumberController.text,
                        "street":streetController.text,
                        "city":cityController.text,
                        "nearby_address":nearbyAddressController.text,
                      }));
                    },
                  ).paddingSymmetric(vertical: 20.h),
                ],
              ).paddingSymmetric(horizontal: 20.w),
            ),
          );
        },
      ),
    );
  }
}

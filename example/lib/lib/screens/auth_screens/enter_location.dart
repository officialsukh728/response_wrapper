part of 'auth_screen.dart';

class EnterLocationScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool leading;

  const EnterLocationScreen({
    super.key, this.latitude, this.longitude, this.address,
    this.leading = true,
  });

  @override
  State<EnterLocationScreen> createState() => _EnterLocationScreenState();
}

class _EnterLocationScreenState extends State<EnterLocationScreen> {
  LatLng? currentLatLng;
  String? address;
  Placemark? placemark;
  PredictionsListModel? placesList;
  List<Marker> markers = [];
  final searchCtrl = TextEditingController();
  bool firstTimeCalled = false;

  Completer<GoogleMapController> completer = Completer();

  @override
  void initState() {
    final position = context
        .read<LocationCubit>()
        .state
        .position;
    address = widget.address;
    searchCtrl.text = widget.address ?? "";
    _goToPosition(LatLng(
      widget.latitude ?? position?.latitude ?? 32.195476,
      widget.longitude ?? position?.longitude ?? 74.2023563,
    ));
    addUpdateMarker();
    super.initState();
  }

  void addUpdateMarker() async {
    if (currentLatLng == null) return;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("0"),
        position: currentLatLng!,
      ),
    );
    setState(() {

    });
  }

  /// go to position
  Future<void> _goToPosition(LatLng latLng) async {
    try {
      printLog("????////");
      firstTimeCalled = true;
      currentLatLng = latLng;
      final GoogleMapController controller = await completer.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 12)));
      setState(() {});
      getLocationRepo
          .getAddressWithLatLang(LatLngModel(latLng.latitude, latLng.longitude))
          .then((value) {
        if (value == null) return;
        address = value[0];
        searchCtrl.text = value[0];
        placemark = value[1];
        setState(() {});
      });
    } catch (e, t) {
      errorLog(e.toString() + t.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(
        leading: widget.leading,
      ),
      body: Stack(
        children: [
          Column(
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
              ).paddingOnly(bottom: 5.h).paddingSymmetric(horizontal: 20.w),
              if (currentLatLng != null)
                Expanded(
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    buildingsEnabled: true,
                    myLocationButtonEnabled: true,
                    indoorViewEnabled: true,
                    onMapCreated: onMapCreated,
                    markers: markers.toSet(),
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: currentLatLng!,
                      zoom: 11.0,
                    ),
                    onCameraMove: (CameraPosition v) {
                      currentLatLng =
                          LatLng(v.target.latitude, v.target.longitude);
                      errorLog("$currentLatLng", fun: "onCameraMoveCalled");
                      setMarkerWA();
                    },
                    onCameraIdle: () {
                      debugPrint("onCameraIdle called");
                      addUpdateMarker();
                    },
                    onTap: (LatLng latLng) {
                      debugPrint("onTap");
                      addUpdateMarker();
                      _goToPosition(latLng);
                    },
                  ),
                )
              else
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              AppCommonButton(
              context: context,
                enable: currentLatLng != null && placemark != null,
                title: "Confirm Location",
                backGroundColor: AppColors.primaryColor,
                width: AppConfig.width * 0.8,
                onTap: () {
                  hideAppKeyboard;
                  context.push(ConfirmLocationScreen(
                    currentLocation: currentLatLng,
                    address: address,
                    placemark: placemark,
                  ));
                },
              ).paddingSymmetric(vertical: 10.h),
            ],
          ),
          placesBox(),
        ],
      ),
    );
  }

  /// go to position without animate
  Future<void> setMarkerWA() async {
    if (firstTimeCalled) {
      firstTimeCalled = false;
    } else {
      if (currentLatLng == null) return;
      getLocationRepo
          .getAddressWithLatLang(
          LatLngModel(currentLatLng!.latitude, currentLatLng!.longitude))
          .then((value) {
        if (value == null) return;
        address = value[0];
        searchCtrl.text = value[0];
        placemark = value[1];
        setState(() {});
      });
    }
  }

    /// [search places ui]
  Widget placesBox() {
    Size size = MediaQuery
        .of(context)
        .size;
    return Positioned(
      top: 70.h,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            controller: searchCtrl,
            hintText: "Enter location...",
            borderColor: Color(0xffAEAEAE),
            onChanged: (value) async {
              PredictionsListModel places =
              await getLocationRepo.locationAutoComplete(value);
              setState(() {
                if (places.predictions?.isEmpty == true) {
                  placesList = null;
                } else {
                  placesList = places;
                }
              });
            },
            suffixIcon: IconButton(
              onPressed: () {
                if (searchCtrl.text.isNotEmpty) {
                  searchCtrl.clear();
                  setState(() {});
                }
              },
              icon: Icon(
                searchCtrl.text.isEmpty ? Icons.search : Icons.close,
                color: Colors.black,
              ),
            ),
          ).paddingOnly(bottom: 10.h).paddingSymmetric(horizontal: 20.w),
          Visibility(
            visible: placesList != null,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var data in (placesList?.predictions ??
                      <PredictionData>[]))
                    ListTile(
                      onTap: () async {
                        if (data.placeId == null) return;
                        PlaceModel place =
                        await getLocationRepo.getPlace(data.placeId ?? '');
                        if (place.result?.geometry?.location?.lat == null ||
                            place.result?.geometry?.location?.lat == null) return;
                        searchCtrl.text = data.description ?? "";
                        FocusScope.of(context).requestFocus(FocusNode());
                        _goToPosition(LatLng(
                          place.result?.geometry?.location?.lat ?? 0,
                          place.result?.geometry?.location?.lng ?? 0,
                        ));

                        setState(() {
                          placesList = null;
                        });
                      },
                      title: SizedBox(
                        width: size.width * 0.8,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: data.description ?? '',
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

    onMapCreated(GoogleMapController controller) {
      if (completer.isCompleted) return;
      completer.complete(controller);
    }
  }

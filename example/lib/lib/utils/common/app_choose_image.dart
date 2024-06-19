import 'dart:io';

import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/gradient_icon.dart';
import 'package:sample/utils/common/image_picker_crop.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/dotted_border/dotted_border.dart';
import 'package:sample/utils/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChooseImageModel {
  final String? localAsset;
  final File? fileImage;
  final String? fromUrl;
  final String? imageId;

  ChooseImageModel({
    this.localAsset,
    this.fileImage,
    this.fromUrl,
    this.imageId,
  });
}

class ChooseImageState {
  final List<ChooseImageModel> imageModelList;
  final bool removingItemLoading;

  ChooseImageState({
    required this.imageModelList,
    required this.removingItemLoading,
  });
factory ChooseImageState.empty() => ChooseImageState(
        imageModelList: [],
        removingItemLoading: false,
      );
  ChooseImageState copyWith({
    List<ChooseImageModel>? imageModelList,
    bool? removingItemLoading,
  }) {
    return ChooseImageState(
      imageModelList: imageModelList ?? this.imageModelList,
      removingItemLoading: removingItemLoading ?? this.removingItemLoading,
    );
  }
}

class ChooseImageBloc extends Cubit<ChooseImageState> {
  ChooseImageBloc() : super(ChooseImageState.empty());

  void addImages(List<ChooseImageModel> imageModelList) {
    int remainingSpace = 10 - state.imageModelList.length;
    int imagesToAdd = imageModelList.length <= remainingSpace ? imageModelList.length : remainingSpace;

    if (imagesToAdd > 0) {
      List<ChooseImageModel> newList = [...state.imageModelList, ...imageModelList.take(imagesToAdd)];
      emit(state.copyWith(imageModelList: newList));
    }

    if (imagesToAdd < imageModelList.length) {
      showSnackBar(message: "Maximum limit of 10 images exceeded");
    }
  }

  void empty() => emit(ChooseImageState.empty());

  void addImageModel(ChooseImageModel imageModel) {
    if (state.imageModelList.length >= 10) {
      showSnackBar(message: "Maximum limit reached");
      return;
    }
    List<ChooseImageModel> newList = [...state.imageModelList, imageModel];
    emit(state.copyWith(imageModelList: newList));
  }

  void removeImageModel(int index) {
    List<ChooseImageModel> newList = List.from(state.imageModelList)
      ..removeAt(index);
    emit(state.copyWith(imageModelList: newList));
  }

  void setRemovingItemLoading(bool isLoading) {
    emit(state.copyWith(removingItemLoading: isLoading));
  }

  void openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 10,);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      addImageModel(ChooseImageModel(fileImage: file));
    }
  }

  void openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 10,);

    for (final pickedFile in pickedFiles) {
      File file = File(pickedFile.path);
      addImageModel(ChooseImageModel(fileImage: file));
    }
  }

  void emitter(ChooseImageState state) => emit(state);
}

class ChooseImageWidget extends StatelessWidget {
  const ChooseImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChooseImageBloc>();
    return BlocBuilder<ChooseImageBloc, ChooseImageState>(
      builder: (context, state) {
        if (state.imageModelList.isEmpty) {
          return AppInkWell(
            onTap: () {
              showImageOptionsBottomSheet(
                context,
                openCamera: () => cubit.openCamera(context),
                openGallery: () => cubit.openGallery(context),
              );
            },
            child: DottedBorder(
              strokeWidth: 1,
              borderType: BorderType.RRect,
              borderPadding: EdgeInsets.zero,
              radius: Radius.circular(12.r),
              child: Container(
                height: 150.h,
                width: AppConfig.width * 0.9,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.share,
                      size: 25.sp,
                      color: AppColors.greyColor,
                    ),
                    10.yHeight,
                    AppText(
                      'Upload from gallery',
                      textAlign: TextAlign.center,
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontFamily: AppFonts.cabinVariable,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: 150.h,
          child: Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ...state.imageModelList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageModel = entry.value;
                  return GestureDetector(
                    key: Key('$index'),
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          width: 150.w,
                          height: 150.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.grey,
                              image: DecorationImage(
                                image: _buildImageWidgetNew(imageModel),
                                fit: BoxFit.cover,
                              )),
                          // child: _buildImageWidget(imageModel),
                        ).paddingOnly(right: 10.w),
                        if (imageModel.fileImage != null)
                          Positioned(
                            top: -3.h,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                cubit.removeImageModel(index);
                                cubit.setRemovingItemLoading(true);
                              },
                              child: const Icon(Icons.cancel,color: Colors.red,),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList()..add(_buildAddButton(context, cubit)),
              ],
              onReorder: (int oldIndex, int newIndex) {
                if(oldIndex>=state.imageModelList.length||newIndex>=state.imageModelList.length)return;
                if (state.imageModelList[oldIndex].localAsset == null &&
                    state.imageModelList[newIndex].localAsset == null) {
                  ChooseImageModel item =
                      state.imageModelList.removeAt(oldIndex);
                  List<ChooseImageModel> newList =
                      List.from(state.imageModelList)..insert(newIndex, item);
                  cubit.emitter(cubit.state.copyWith(imageModelList: newList));
                }
              },
            ),
          ),
        );
      },
    );
  }

  ImageProvider _buildImageWidgetNew(ChooseImageModel imageModel) {
    if (imageModel.localAsset != null) {
      return AssetImage(imageModel.localAsset!);
    } else if (imageModel.fileImage != null) {
      return FileImage(imageModel.fileImage!);
    } else if (imageModel.fromUrl != null) {
      return CachedNetworkImageProvider(imageModel.fromUrl!);
    } else {
      return CachedNetworkImageProvider(dummyUserImageLink);
    }
  }

  GestureDetector _buildAddButton(BuildContext context, ChooseImageBloc cubit) {
    return GestureDetector(
      key: const Key("GestureDetector-buildAddButton"),
      onTap: () {
        showImageOptionsBottomSheet(
          context,
          openCamera: () => cubit.openCamera(context),
          openGallery: () => cubit.openGallery(context),
        );
      },
      child: DottedBorder(
        strokeWidth: 1,
        borderType: BorderType.RRect,
        borderPadding: EdgeInsets.zero,
        radius: Radius.circular(15.r),
        child: Container(
          width: 150.w,
          height: 150.w,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          child:  Center(
            child: GradientIcon(
              icon:Icons.add,
              size: 50.w,
            ),
          ),
        ),
      )
      /*child: Container(
        width: 150.w,
        height: 150.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.grey,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: getLinearGradient,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 50.sp,
            ),
          ),
        ),
      )*/.paddingOnly(right: 10),
    );
  }
}

part of 'profile_screen.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String? name;
  final double? width;
  final double? height;
  final void Function()? onTap;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.imagePath,
    this.name,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppInkWell(
          onTap: () {
            if (imagePath != null || imageUrl != null) {
              if (imagePath != null) {
                context.push(PhotoVideoViewZoom(
                  filePaths: [imagePath!],
                ));
              } else if (imageUrl != null) {
                context.push(PhotoVideoViewZoom(
                  urls: [imageUrl!],
                ));
              }
            }
          },
          child: Container(
            width:width?? 135.h,
            height:height?? 135.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.black,
                width: 1.w,
              ),
              image:(imagePath != null || imageUrl != null)? buildDecorationImage(
                imagePath: imagePath,
                imageUrl: imageUrl,
              ):null,
            ),
            child:(imagePath != null || imageUrl != null)?null: buildAvatarContainer(
              width: width??135.h,
              height:height?? 135.h,
              image: null,
              name: name??"T",
              context: context
            ),
          ),
        ),
        if(onTap!=null)
        Positioned(
          bottom: 8.h,
          right: 2.h,
          child: Center(
            child: AppCommonImage(
              onTap: onTap,
              height: 30.h,
              width: 30.h,
              imagePath: AppImagesPath.appCameraProfile,
            ),
          ),
        )
      ],
    );
  }

  DecorationImage? buildDecorationImage({
    String? imagePath,
    String? imageUrl,
  }) {
    ImageProvider imageProvider;

    if (imagePath != null) {
      imageProvider = FileImage(File(imagePath));
    } else if (imageUrl != null) {
      imageProvider = CachedNetworkImageProvider(
        imageUrl,
        maxHeight: (height??135.h).toInt(),
        maxWidth: (width??135.h).toInt(),
      );
    } else {
      imageProvider = AssetImage(AppImagesPath.profileIcon);
    }

    return DecorationImage(
      image: imageProvider,
      fit: BoxFit.cover,
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';

import 'app_video_player.dart';
class PhotoVideoViewZoom extends StatelessWidget {
  final List<String> urls;
  final List<String> filePaths;
  final String? videoUrl;
  final int initialIndex;

  const PhotoVideoViewZoom({
    Key? key,
    this.urls = const <String>[],
    this.initialIndex = 0,
    this.videoUrl,
    this.filePaths = const <String>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: urls.length + (videoUrl != null ? 1 : 0) + filePaths.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              if (index < urls.length) {
                /// Display network image
                return PhotoView(
                  imageProvider: NetworkImage(urls[index]),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              } else if (index < urls.length + filePaths.length) {
                /// Display local file image
                int localIndex = index - urls.length;
                return PhotoView(
                  imageProvider: FileImage(File(filePaths[localIndex])),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              } else {
                /// Display video
                return ProfileNetworkVideoPlayer(
                  size: 70.w,
                  showControls: true,
                  videoUrl: videoUrl ?? dummyUserVideoLink,
                );
              }
            },
          ),
          Positioned(
            top: 50.h,
            left: 20.w,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                radius: 18.r,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 22.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


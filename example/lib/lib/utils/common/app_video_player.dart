import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:video_player/video_player.dart';

class ProfileAssetsVideoPlayer extends StatefulWidget {
  const ProfileAssetsVideoPlayer({
    Key? key,
    required this.path,
    this.isPlay = true,
    this.aspectRatio,
  }) : super(key: key);

  final String path;
  final bool isPlay;
  final double? aspectRatio;

  @override
  _ProfileAssetsVideoPlayerState createState() =>
      _ProfileAssetsVideoPlayerState();
}

class _ProfileAssetsVideoPlayerState extends State<ProfileAssetsVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.isPlay ? _controller.play() : _controller.pause();
    final aspectRatio = (widget.aspectRatio) != null
        ? (widget.aspectRatio ?? 1)
        : _controller.value.aspectRatio;
    return _controller.value.isInitialized == false
        ? const Center(child: CircularProgressIndicator())
        : ClipRRect(
            borderRadius: BorderRadius.circular(7.r),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
  }
}

class AssetVideoPlayer extends StatefulWidget {
  AssetVideoPlayer({
    Key? key,
    required this.path,
    this.isPlay = true,
    this.aspectRatio,
  }) : super(key: key);

  String path;
  bool isPlay;
  double? aspectRatio;

  @override
  _AssetVideoPlayerState createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<AssetVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset(widget.path)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.isPlay ? _controller.play() : _controller.pause();
    final aspectRatio = (widget.aspectRatio) != null
        ? (widget.aspectRatio ?? 1)
        : _controller.value.aspectRatio;
    return _controller.value.isInitialized == false
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ],
          );
  }
}

class FileVideoPlayer extends StatefulWidget {
  const FileVideoPlayer({
    Key? key,
    required this.filePath,
    required this.isPlay,
    this.aspectRatio,
  }) : super(key: key);

  final String filePath;
  final bool isPlay;
  final double? aspectRatio;

  @override
  _FileVideoPlayerState createState() => _FileVideoPlayerState();
}

class _FileVideoPlayerState extends State<FileVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    errorLog(widget.filePath, fun: 'path');
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.isPlay ? _controller.play() : _controller.pause();
    final aspectRatio = (widget.aspectRatio) != null
        ? (widget.aspectRatio ?? 1)
        : _controller.value.aspectRatio;
    return _controller.value.isInitialized == false
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ],
          );
  }
}

class ProfileNetworkVideoPlayer extends StatefulWidget {
  const ProfileNetworkVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.size,
    this.showControls = false,
    this.aspectRatio,
  }) : super(key: key);

  final String videoUrl;
  final bool showControls;
  final double? aspectRatio;
  final double? size;

  @override
  ProfileNetworkVideoPlayerState createState() =>
      ProfileNetworkVideoPlayerState();
}

class ProfileNetworkVideoPlayerState extends State<ProfileNetworkVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
            ..initialize().then((_) {
              setState(() {});
              _chewieController = ChewieController(
                videoPlayerController: _controller,
                showControls: widget.showControls,
              );
              setState(() {});
            });
    } catch (e, t) {
      errorLog(e.toString() + t.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double
    aspectRatio = widget.aspectRatio ??_controller.value.aspectRatio;
    if (_chewieController == null||_controller.value.isInitialized == false) {
      return Shimmer.fromColors(
        highlightColor: highlightColorShimmer,
        baseColor: baseColorShimmer,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap:(!widget.showControls)?null: () {
                  if (!widget.showControls) return;
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  setState(() {});
                },
                child: /*!widget.playingBtnShowing?VideoPlayer(_controller):*/Chewie(
                  controller: _chewieController!,
                ),
              ),
              // if (!_controller.value.isPlaying&&widget.playingBtnShowing)
              //   Align(
              //     alignment: Alignment.center,
              //     child: IconButton(
              //       onPressed: () {
              //         _controller.value.isPlaying
              //             ? _controller.pause()
              //             : _controller.play();
              //         setState(() {});
              //       },
              //       icon: Icon(
              //         _controller.value.isPlaying
              //             ? Icons.pause_circle_filled
              //             : Icons.play_circle,
              //         color: AppColors.primaryColor,
              //         size: widget.size??25.h,
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      );
    }
  }

// Method to play the video
  void playVideo() {
    if (_controller.value.isPlaying) {
      return;
    }
    _controller.play();
  }

  // Method to pause the video
  void pauseVideo() {
    if (!_controller.value.isPlaying) {
      return;
    }
    _controller.pause();
  }
}

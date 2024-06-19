// import 'dart:async';
// import 'dart:io';
//
// import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
// import 'package:ffmpeg_kit_flutter_video/log.dart';
// import 'package:ffmpeg_kit_flutter_video/return_code.dart';
// import 'package:ffmpeg_kit_flutter_video/session.dart';
// import 'package:ffmpeg_kit_flutter_video/statistics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_image_generator/qr_image_generator.dart';
// import 'package:trillboards/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
// import 'package:trillboards/utils/common/app_bar/common_app_bar.dart';
// import 'package:trillboards/utils/common/app_video_player.dart';
// import 'package:trillboards/utils/common/navigator_extension.dart';
// import 'package:trillboards/utils/common/print_log.dart';
// import 'package:trillboards/utils/photo_to_video_utills/abstract.dart';
// import 'package:trillboards/utils/photo_to_video_utills/decoration.dart';
// import 'package:trillboards/utils/photo_to_video_utills/player.dart';
// import 'package:trillboards/utils/photo_to_video_utills/popup.dart';
// import 'package:trillboards/utils/photo_to_video_utills/progress_modal.dart';
// import 'package:trillboards/utils/photo_to_video_utills/test_api.dart';
// import 'package:trillboards/utils/photo_to_video_utills/util.dart';
// import 'package:trillboards/utils/photo_to_video_utills/video_tab.dart';
// import 'package:trillboards/utils/photo_to_video_utills/video_util.dart';
//
// class VideoImageOverlay {
//   static Future addImageOverlay({
//     required BuildContext context,
//     required ValueChanged<File?> generatedVideo,
//   }) async {
//     try {
//       final videoFile =
//       await context.read<ImageVideoSelectionBloc>().getVideoPicker();
//       if (videoFile == null) return null;
//       final String videoPath = videoFile.path;
//       final String imagePath = (await saveQRImage("www.google.com")).path;
//       final Directory tempDir = await getTemporaryDirectory();
//       final outputFile =
//       File('${tempDir.path}/${DateTime.now().toIso8601String()}.mp4');
//       final String outputPath = outputFile.path;
//       final ffmpegCommand =
//           '-i $videoPath -i $imagePath -filter_complex "overlay=10:10" $outputPath';
//
//       executeCallback(Session session) async {
//         final state =
//         FFmpegKitConfig.sessionStateToString(await session.getState());
//         final returnCode = await session.getReturnCode();
//         final failStackTrace = await session.getFailStackTrace();
//         final duration = await session.getDuration();
//         if (ReturnCode.isSuccess(returnCode)) {
//           ffprint(
//               "Encode completed successfully in ${duration} milliseconds; playing video.");
//           generatedVideo(outputFile);
//         } else {
//           showPopup("Encode failed. Please check log for the details.");
//           ffprint(
//               "Encode failed with state ${state} and rc ${returnCode}.${notNull(failStackTrace, "\\n")}");
//         }
//         printLog(
//             'FFmpeg process exited with state ${session.getState()} and rc ${session.getReturnCode()}');
//       }
//
//       logCallback(Log log) {
//         printLog(log.getMessage());
//       }
//
//       statisticsCallback(Statistics statistics) {
//         printLog('FFmpeg process statistics: ${statistics.getTime()}');
//       }
//
//       await FFmpegKit.executeAsync(
//         ffmpegCommand,
//         executeCallback,
//         logCallback,
//         statisticsCallback,
//       );
//       infoLog(outputFile, fun: "outputFile => ");
//     } catch (e, t) {
//       errorLog(e.toString() + t.toString(), fun: "addImageOverlay");
//     }
//     return null;
//   }
// }
//
// class QRImageGeneratorNew extends StatefulWidget {
//   const QRImageGeneratorNew({super.key, this.title = "Test"});
//
//   final String title;
//
//   @override
//   State<QRImageGeneratorNew> createState() => _QRImageGeneratorNewState();
// }
//
// class _QRImageGeneratorNewState extends State<QRImageGeneratorNew>
//     with TickerProviderStateMixin
//     implements RefreshablePlayerDialogFactory {
//   final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
//   ProgressModal? progressModal;
//   VideoTab videoTab = VideoTab();
//   File? videoFile;
//
//   @override
//   void refresh() {
//     setState(() {});
//     context.read<ImageVideoSelectionBloc>().rebuild();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     videoTab.init(this);
//     videoTab.setActive();
//     FFmpegKitConfig.init().then((_) {
//       VideoUtil.prepareAssets();
//       VideoUtil.registerApplicationFonts();
//       Test.testCommonApiMethods();
//       Test.testParseArguments();
//       Test.setSessionHistorySizeTest();
//     });
//   }
//
//   @override
//   void dialogHide() {
//     if (progressModal != null) {
//       progressModal?.hide();
//     }
//   }
//
//   @override
//   void dialogShowCancellable(String message, Function cancelFunction) {
//     progressModal = ProgressModal(scaffoldStateKey.currentContext!);
//     progressModal?.show(message, cancelFunction: cancelFunction);
//   }
//
//   @override
//   void dialogShow(String message) {
//     progressModal = ProgressModal(scaffoldStateKey.currentContext!);
//     progressModal?.show(message);
//   }
//
//   @override
//   void dialogUpdate(String message) {
//     progressModal?.update(message: message);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldStateKey,
//       appBar: AppBarCommon(
//         actions: [
//           ElevatedButton(
//               onPressed: () {
//                 videoTab.addImageInVideo(
//                   context: context,
//                   generatedVideo: (value) {
//                     setState(() {
//                       videoFile = value;
//                     });
//                   },
//                 );
//               },
//               child: Text("Make")).paddingOnly(right: 5.w),
//           ElevatedButton(
//               onPressed: () async {
//                 final video =
//                 await context.read<ImageVideoSelectionBloc>().getVideoPicker();
//                 if (video == null) return;
//                 videoTab.addImageOverlayVideo(
//                   videoFile: video,
//                   url: "www.www.www",
//                   generatedVideo: (value) {
//                     setState(() {
//                       videoFile = null;
//                       videoFile = value;
//                     });
//                   },
//                 );
//               },
//               child: Text("OverLay")).paddingOnly(right: 5.w),
//         ],
//       ),
//       body: Column(
//         children: [
//           // SizedBox(
//           //   height: 200,
//           //   child: FutureBuilder(
//           //     future: saveQRImage("www.google.com"),
//           //     builder: (context, snapshot) {
//           //       if (snapshot.connectionState == ConnectionState.waiting) {
//           //         return const CircularProgressIndicator();
//           //       } else if (snapshot.hasError) {
//           //         return Text('Error: ${snapshot.error}');
//           //       } else {
//           //         return PhotoView(
//           //           imageProvider: FileImage(snapshot.data ?? File("")),
//           //           minScale: PhotoViewComputedScale.contained * 0.8,
//           //           maxScale: PhotoViewComputedScale.covered * 2,
//           //         );
//           //       }
//           //     },
//           //   ),
//           // ),
//           if(videoFile!=null)
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(20.0),
//                 padding: const EdgeInsets.all(4.0),
//                 child: FileVideoPlayer(filePath: videoFile?.path??"", isPlay: true,),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// Future<File> saveQRImage(String url) async {
//   final Directory tempDir = await getApplicationDocumentsDirectory();
//   final String filePath =
//       "${tempDir.path}/${DateTime.now().toIso8601String()}.png";
//   final path = await QRGenerator().generate(
//     data: url,
//     filePath: filePath,
//     scale: 10,
//     padding: 2,
//     foregroundColor: Colors.black,
//     backgroundColor: Colors.white,
//     errorCorrectionLevel: ErrorCorrectionLevel.medium,
//   );
//   printLog(path, fun: "saveQRImage");
//   return File(path);
// }
///*
//  * Copyright (c) 2018-2022 Taner Sener
//  *
//  * Permission is hereby granted, free of charge, to any person obtaining a copy
//  * of this software and associated documentation files (the "Software"), to deal
//  * in the Software without restriction, including without limitation the rights
//  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  * copies of the Software, and to permit persons to whom the Software is
//  * furnished to do so, subject to the following conditions:
//  *
//  * The above copyright notice and this permission notice shall be included in all
//  * copies or substantial portions of the Software.
//  *
//  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  * SOFTWARE.
//  */
//
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
// import 'package:ffmpeg_kit_flutter_video/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter_video/ffprobe_session.dart';
// import 'package:ffmpeg_kit_flutter_video/log.dart';
// import 'package:ffmpeg_kit_flutter_video/return_code.dart';
// import 'package:ffmpeg_kit_flutter_video/session.dart';
// import 'package:ffmpeg_kit_flutter_video/statistics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:trillboards/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
// import 'package:trillboards/utils/common/print_log.dart';
// import 'package:trillboards/utils/photo_to_video_utills/QRImageGenerator.dart';
// import 'package:video_player/video_player.dart';
//
// import 'abstract.dart';
// import 'player.dart';
// import 'popup.dart';
// import 'util.dart';
// import 'video_util.dart';
//
// class VideoTab implements PlayerTab {
//   VideoPlayerController? _videoPlayerController;
//   late RefreshablePlayerDialogFactory _refreshablePlayerDialogFactory;
//   late String _selectedCodec;
//   late Statistics? _statistics;
//
//   void init(RefreshablePlayerDialogFactory refreshablePlayerDialogFactory) {
//     _refreshablePlayerDialogFactory = refreshablePlayerDialogFactory;
//     List<DropdownMenuItem<String>> videoCodecList = getVideoCodecList();
//     _selectedCodec = videoCodecList[0].value!;
//     _statistics = null;
//   }
//
//   void setActive() {
//     FFmpegKitConfig.enableLogCallback(null);
//     FFmpegKitConfig.enableStatisticsCallback(null);
//   }
//
//   void changedVideoCodec(String? selectedCodec) {
//     _selectedCodec = selectedCodec!;
//     _refreshablePlayerDialogFactory.refresh();
//   }
//
//   void encodeVideo() {
//     VideoUtil.assetPath(VideoUtil.ASSET_1).then((image1Path) {
//       VideoUtil.assetPath(VideoUtil.ASSET_2).then((image2Path) {
//         VideoUtil.assetPath(VideoUtil.ASSET_3).then((image3Path) {
//           getVideoFile().then((videoFile) {
//             // IF VIDEO IS PLAYING STOP PLAYBACK
//             pause();
//
//             deleteFile(videoFile);
//
//             final String videoCodec = getSelectedVideoCodec();
//
//             ffprint("Testing VIDEO encoding with '$videoCodec' codec");
//
//             hideProgressDialog();
//             showProgressDialog();
//
//             final ffmpegCommand =
//                 VideoUtil.generateEncodeVideoScriptWithCustomPixelFormat(
//                     image1Path: image1Path,
//                     image2Path: image2Path,
//                     image3Path: image3Path,
//                     image4Path: image3Path,
//                     videoFilePath: videoFile.path,
//                     videoCodec: videoCodec,
//                     pixelFormat: getPixelFormat(),
//                     customOptions: getCustomOptions());
//
//             ffprint(
//                 "FFmpeg process started with arguments: '$ffmpegCommand'.");
//
//             FFmpegKit.executeAsync(
//                     ffmpegCommand,
//                     (session) async {
//                       final state = FFmpegKitConfig.sessionStateToString(
//                           await session.getState());
//                       final returnCode = await session.getReturnCode();
//                       final failStackTrace = await session.getFailStackTrace();
//                       final duration = await session.getDuration();
//
//                       hideProgressDialog();
//
//                       if (ReturnCode.isSuccess(returnCode)) {
//                         ffprint(
//                             "Encode completed successfully in $duration milliseconds; playing video.");
//                         playVideo();
//                       } else {
//                         showPopup(
//                             "Encode failed. Please check log for the details.");
//                         ffprint(
//                             "Encode failed with state $state and rc $returnCode.${notNull(failStackTrace, "\\n")}");
//                       }
//                     },
//                     (log) => ffprint(log.getMessage()),
//                     (statistics) {
//                       _statistics = statistics;
//                       updateProgressDialog();
//                     })
//                 .then((session) => ffprint(
//                     "Async FFmpeg process started with sessionId ${session.getSessionId()}."));
//           });
//         });
//       });
//     });
//   }
//
//   Future encodeVideoFromImagePath({
//     required String image1Path,
//     required String image2Path,
//     required String image3Path,
//     required String image4Path,
//     required ValueChanged<File?> generatedVideo,
//   }) async {
//     final videoFile = await getVideoFile();
//     await pause();
//     deleteFile(videoFile);
//     final String videoCodec = getSelectedVideoCodec();
//     ffprint("Testing VIDEO encoding with '$videoCodec' codec");
//     hideProgressDialog();
//     showProgressDialog();
//     final ffmpegCommand =
//         VideoUtil.generateEncodeVideoScriptWithCustomPixelFormat(
//             image1Path: image1Path,
//             image2Path: image2Path,
//             image3Path: image3Path,
//             image4Path: image3Path,
//             videoFilePath: videoFile.path,
//             videoCodec: videoCodec,
//             pixelFormat: getPixelFormat(),
//             customOptions: getCustomOptions());
//     ffprint("FFmpeg process started with arguments: '$ffmpegCommand'.");
//     final session = await FFmpegKit.executeAsync(
//         ffmpegCommand,
//         (session) async {
//           final state =
//               FFmpegKitConfig.sessionStateToString(await session.getState());
//           final returnCode = await session.getReturnCode();
//           final failStackTrace = await session.getFailStackTrace();
//           final duration = await session.getDuration();
//           hideProgressDialog();
//
//           if (ReturnCode.isSuccess(returnCode)) {
//             ffprint(
//                 "Encode completed successfully in $duration milliseconds; playing video.");
//             generatedVideo(videoFile);
//           } else {
//             showPopup("Encode failed. Please check log for the details.");
//             ffprint(
//                 "Encode failed with state $state and rc $returnCode.${notNull(failStackTrace, "\\n")}");
//             generatedVideo(null);
//           }
//         },
//         (log) => ffprint(log.getMessage()),
//         (statistics) {
//           _statistics = statistics;
//           updateProgressDialog();
//         });
//     ffprint(
//         "Async FFmpeg process started with sessionId ${session.getSessionId()}.");
//   }
//
//   Future addImageInVideo({
//     required BuildContext context,
//     required ValueChanged<File?> generatedVideo,
//   }) async {
//     try {
//       final videoFile =
//           await context.read<ImageVideoSelectionBloc>().getVideoPicker();
//       if (videoFile == null) return null;
//       await pause();
//       hideProgressDialog();
//       showProgressDialog();
//       final String videoPath = videoFile.path;
//       final File imageFile = await saveQRImage("www.google.com");
//       final String imagePath = imageFile.path;
//
//       final Directory tempDir = await getTemporaryDirectory();
//       final outputFile =
//           File('${tempDir.path}/${DateTime.now().toIso8601String()}.mp4');
//       final String outputPath = outputFile.path;
//
//       // Get the duration of the video using FFprobe
//       final FFprobeSession response = await FFprobeKit.execute(
//         '-i $videoPath -show_entries format=duration -v quiet -of csv="p=0"',
//       );
//       final duration = await response.getDuration();
//
//       // Execute FFmpeg command to add image overlay to the end of the video
//       final ffmpegCommand =
//           '-i $videoPath -i $imagePath -filter_complex "[1:v]scale=iw:ih[v1];[0:v][v1]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2:enable=\'between(t,$duration,$duration+1)\'" -c:a copy $outputPath';
//
//       executeCallback(Session session) async {
//         final returnCode = await session.getReturnCode();
//         if (ReturnCode.isSuccess(returnCode)) {
//           generatedVideo(outputFile);
//           playVideo();
//         } else {
//           generatedVideo(null);
//           showPopup('Encode failed. Please check log for the details.');
//         }
//         hideProgressDialog();
//       }
//
//       logCallback(Log log) {
//         ffprint(log.getMessage());
//       }
//
//       statisticsCallback(Statistics statistics) {
//         _statistics = statistics;
//         updateProgressDialog();
//       }
//
//       await FFmpegKit.executeAsync(
//         ffmpegCommand,
//         executeCallback,
//         logCallback,
//         statisticsCallback,
//       );
//       infoLog(outputFile, fun: 'outputFile => ');
//     } catch (e, t) {
//       hideProgressDialog();
//       generatedVideo(null);
//       errorLog(e.toString() + t.toString(), fun: "addImageOverlay");
//     }
//     return null;
//   }
//
//   Future addImageOverlayVideo({
//     required File videoFile,
//     required String url,
//     required ValueChanged<File?> generatedVideo,
//   }) async {
//     try {
//       hideProgressDialog();
//       showProgressDialog();
//       final String videoPath = videoFile.path;
//       final String imagePath = (await saveQRImage(url)).path;
//       final Directory tempDir = await getTemporaryDirectory();
//       final outputFile = File('${tempDir.path}/${DateTime.now().toIso8601String()}.mp4');
//       final String outputPath = outputFile.path;
//       final ffmpegCommand =
//           '-i $videoPath -i $imagePath -filter_complex "overlay=10:10" $outputPath';
//
//       executeCallback(Session session) async {
//         final returnCode = await session.getReturnCode();
//         if (ReturnCode.isSuccess(returnCode)) {
//           generatedVideo(outputFile);
//         } else {
//           showPopup("Encode failed. Please check log for the details.");
//         }
//         hideProgressDialog();
//       }
//
//       logCallback(Log log) {
//         printLog(log.getMessage());
//       }
//
//       statisticsCallback(Statistics statistics) {
//         _statistics = statistics;
//         updateProgressDialog();
//       }
//       await FFmpegKit.executeAsync(
//         ffmpegCommand,
//         executeCallback,
//         logCallback,
//         statisticsCallback,
//       );
//       infoLog(outputFile, fun: "outputFile => ");
//     } catch (e, t) {
//       hideProgressDialog();
//       generatedVideo(null);
//       errorLog(e.toString() + t.toString(), fun: "addImageOverlay");
//     }
//     return null;
//   }
//   Future<void> playVideo() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       if (_videoPlayerController != null) {
//         await _videoPlayerController!.initialize();
//         await _videoPlayerController!.play();
//       }
//       _refreshablePlayerDialogFactory.refresh();
//     }
//   }
//
//   Future<void> pause() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       if (_videoPlayerController != null) {
//         await _videoPlayerController!.pause();
//       }
//       _refreshablePlayerDialogFactory.refresh();
//     }
//   }
//
//   getPixelFormat() {
//     String videoCodec = _selectedCodec;
//
//     String pixelFormat;
//     if (videoCodec == "x265") {
//       pixelFormat = "yuv420p10le";
//     } else {
//       pixelFormat = "yuv420p";
//     }
//
//     return pixelFormat;
//   }
//
//   String getSelectedVideoCodec() {
//     String videoCodec = _selectedCodec;
//
//     // VIDEO CODEC MENU HAS BASIC NAMES, FFMPEG NEEDS LONGER LIBRARY NAMES.
//     // APPLYING NECESSARY TRANSFORMATION HERE
//     switch (videoCodec) {
//       case "x264":
//         videoCodec = "libx264";
//         break;
//       case "h264_mediacodec":
//         videoCodec = "h264_mediacodec";
//         break;
//       case "hevc_mediacodec":
//         videoCodec = "hevc_mediacodec";
//         break;
//       case "openh264":
//         videoCodec = "libopenh264";
//         break;
//       case "x265":
//         videoCodec = "libx265";
//         break;
//       case "xvid":
//         videoCodec = "libxvid";
//         break;
//       case "vp8":
//         videoCodec = "libvpx";
//         break;
//       case "vp9":
//         videoCodec = "libvpx-vp9";
//         break;
//       case "aom":
//         videoCodec = "libaom-av1";
//         break;
//       case "kvazaar":
//         videoCodec = "libkvazaar";
//         break;
//       case "theora":
//         videoCodec = "libtheora";
//         break;
//     }
//
//     return videoCodec;
//   }
//
//   Future<File> getVideoFile() async {
//     String videoCodec = _selectedCodec;
//
//     String extension;
//     switch (videoCodec) {
//       case "vp8":
//       case "vp9":
//         extension = "webm";
//         break;
//       case "aom":
//         extension = "mkv";
//         break;
//       case "theora":
//         extension = "ogv";
//         break;
//       case "hap":
//         extension = "mov";
//         break;
//       default:
//         // mpeg4, x264, h264_mediacodec, hevc_mediacodec, x265, xvid, kvazaar
//         extension = "mp4";
//         break;
//     }
//
//     final String video = "video.$extension";
//     Directory documentsDirectory = await VideoUtil.documentsDirectory;
//     return File("${documentsDirectory.path}/$video");
//   }
//
//   String getCustomOptions() {
//     String videoCodec = _selectedCodec;
//
//     switch (videoCodec) {
//       case "x265":
//         return "-crf 28 -preset fast ";
//       case "vp8":
//         return "-b:v 1M -crf 10 ";
//       case "vp9":
//         return "-b:v 2M ";
//       case "aom":
//         return "-crf 30 -strict experimental ";
//       case "theora":
//         return "-qscale:v 7 ";
//       case "hap":
//         return "-format hap_q ";
//       default:
//         // kvazaar, mpeg4, x264, h264_mediacodec, hevc_mediacodec, xvid
//         return "";
//     }
//   }
//
//   List<DropdownMenuItem<String>> getVideoCodecList() {
//     List<DropdownMenuItem<String>> list = List.empty(growable: true);
//
//     list.add(const DropdownMenuItem(
//         value: "mpeg4",
//         child: SizedBox(width: 130, child: Center(child: Text("mpeg4")))));
//     list.add(const DropdownMenuItem(
//         value: "x264",
//         child: SizedBox(width: 130, child: Center(child: Text("x264")))));
//     list.add(const DropdownMenuItem(
//         value: "h264_mediacodec",
//         child: SizedBox(
//             width: 130, child: Center(child: Text("h264_mediacodec")))));
//     list.add(const DropdownMenuItem(
//         value: "hevc_mediacodec",
//         child: SizedBox(
//             width: 130, child: Center(child: Text("hevc_mediacodec")))));
//     list.add(const DropdownMenuItem(
//         value: "openh264",
//         child: SizedBox(width: 130, child: Center(child: Text("openh264")))));
//     list.add(const DropdownMenuItem(
//         value: "x265",
//         child: SizedBox(width: 130, child: Center(child: Text("x265")))));
//     list.add(const DropdownMenuItem(
//         value: "xvid",
//         child: SizedBox(width: 130, child: Center(child: Text("xvid")))));
//     list.add(const DropdownMenuItem(
//         value: "vp8",
//         child: SizedBox(width: 130, child: Center(child: Text("vp8")))));
//     list.add(const DropdownMenuItem(
//         value: "vp9",
//         child: SizedBox(width: 130, child: Center(child: Text("vp9")))));
//     list.add(const DropdownMenuItem(
//         value: "aom",
//         child: SizedBox(width: 130, child: Center(child: Text("aom")))));
//     list.add(const DropdownMenuItem(
//         value: "kvazaar",
//         child: SizedBox(width: 130, child: Center(child: Text("kvazaar")))));
//     list.add(const DropdownMenuItem(
//         value: "theora",
//         child: SizedBox(width: 130, child: Center(child: Text("theora")))));
//     list.add(const DropdownMenuItem(
//         value: "hap",
//         child: SizedBox(width: 130, child: Center(child: Text("hap")))));
//
//     return list;
//   }
//
//   void showProgressDialog() {
//     _statistics = null;
//     _refreshablePlayerDialogFactory.dialogShow("Loading....");
//   }
//
//   void updateProgressDialog() {
//     _refreshablePlayerDialogFactory
//         .dialogUpdate("Loading....");
//     _refreshablePlayerDialogFactory.refresh();
//   }
//
//   void hideProgressDialog() {
//     _refreshablePlayerDialogFactory.dialogHide();
//   }
//
//   String getSelectedCodec() => _selectedCodec;
//
//   @override
//   void setController(VideoPlayerController controller) {
//     _videoPlayerController = controller;
//   }
// }
//
// Future<void> videoMakerFromImagePaths({
//   required VideoTab videoTab,
//   required List<File> imageFileList,
//   required void Function(File?) generatedVideo,
// }) async {
//   if (imageFileList.isEmpty) {
//     generatedVideo(null);
//     return;
//   }
//   final List<String> imagePaths = [];
//   for (var i = 0; i < 4; i++) {
//     if (i < imageFileList.length) {
//       imagePaths.add(imageFileList[i].path);
//     } else {
//       imagePaths.add(imageFileList.first.path);
//     }
//   }
//
//   try {
//     await videoTab.encodeVideoFromImagePath(
//       image1Path: imagePaths[0],
//       image2Path: imagePaths[1],
//       image3Path: imagePaths[2],
//       image4Path: imagePaths[3],
//       generatedVideo: generatedVideo,
//     );
//   } catch (e) {
//     errorLog('Error encoding video: $e', fun: "videoMakerFromImagePaths");
//   }
// }
//
// Future<void> launchWhatsapp(BuildContext context) async {
//   try {
//     var contact = "+96171556000";
//     FocusManager.instance.primaryFocus?.unfocus();
//     var whatsappAndroid =
//     Uri.parse("whatsapp://send?phone=$contact" +
//         "&text=${Uri.encodeComponent("Hello")}");
//     var whatsappIos = Uri.parse("https://wa.me/$contact/?text=${Uri.parse("Hello")}");
//
//     final url=Platform.isIOS?whatsappIos:whatsappAndroid;
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       if (context.mounted) {
//         showSnackBar(
//             context: context,
//             message: "WhatsApp is not installed on the device",
//             snackBarBehavior: SnackBarBehavior.floating);
//       }
//     }
//   } catch (e, t) {
//     errorLog(e.toString() + t.toString(), fun: "_launchWhatsapp");
//   }
//   return;
// }
//
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample/utils/common/app_snackbar.dart';

import 'common/print_log.dart';

class ImageDownloadController extends GetxController {
  RxBool showLoading = false.obs;
  RxDouble progress = 0.0.obs;

  Future<bool> isImageDownloaded(String imageUrl) async {
    final Uri uri = Uri.parse(imageUrl);
    final String fileName = uri.pathSegments.last;
    var localPath = fileName;
    if (!imageUrl.startsWith('http')) return true;
    final documentsDir = (await getApplicationDocumentsDirectory()).path;
    localPath = '$documentsDir/$fileName';
    final file = File(localPath);
    return (file.existsSync());
  }

  Future<void> downloadImage(String imageUrl) async =>
      await saveDocument(imageUrl);

  Future<dynamic> saveDocument(String imageUrl) async {
    List<int> bytes = [];
    final Uri uri = Uri.parse(imageUrl);
    final String name = uri.pathSegments.last;
    if (!imageUrl.startsWith('http')) return;
    if (Platform.isAndroid) {
      infoLog("isAndroid");
      try {
        printLog(imageUrl, fun: "imageUrl");
        final response = await http.get(Uri.parse(imageUrl));
        progress.value = 100;
        printLog(response.body, fun: "Response");
        if (response.statusCode == 200) {
          bytes = (response.bodyBytes);
          progress.value = 00;
        } else {
          progress.value = 00;
          errorLog('Request failed with status code: ${response.statusCode}');
        }
      } catch (error) {
        progress.value = 00;
        errorLog('Error downloading file: $error');
      }
      if (bytes.isEmpty) return;
      const folderName = "Download";
      final path = Directory('/storage/emulated/0/$folderName');
      if (!(await path.exists())) await path.create();
      final file = File('${path.uri.path}$name');
      infoLog('file saved at this path >>> ${file.path}');
      await file.writeAsBytes(bytes);
      showSnackBar(message: "Image saved to successfully");
      return file;
    } else {
      /// iOS-specific code
      await IosImageDownloader.downloadImage(imageUrl);
      return;
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      return (await Permission.storage.request()).isGranted;
    } else {
      return status.isGranted;
    }
  }
}

class IosImageDownloader {
  static const MethodChannel _channel =
      MethodChannel('flutter_image_downloader');

  static Future<void> downloadImage(String imageUrl) async {
    try {
      final Uri uri = Uri.parse(imageUrl);
      final String name = uri.pathSegments.last;
      await _channel
          .invokeMethod('downloadImage', {'imageUrl': imageUrl, 'path': name});
      showSnackBar(message: "Image saved to successfully");
    } catch (e) {
      errorLog('Error invoking downloadImage method: $e');
    }
  }
}
///import UIKit
/// import Flutter
/// import Photos
/// import GoogleMaps
///
/// @UIApplicationMain
/// @objc class AppDelegate: FlutterAppDelegate {
///     override func application(
///         _ application: UIApplication,
///         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
///     ) -> Bool {
///         GMSServices.provideAPIKey("AIzaSyAvpMAnMMRYUgNJjeqfZRTJVt1BfQ-HyEw")
///
///         // Add this line to register the plugin
///         SwiftFlutterImageDownloaderPlugin.register(with: self.registrar(forPlugin: "FlutterImageDownloader")!)
///
///         GeneratedPluginRegistrant.register(with: self)
///         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
///     }
/// }
///
/// public class SwiftFlutterImageDownloaderPlugin: NSObject, FlutterPlugin {
///
///     public static func register(with registrar: FlutterPluginRegistrar) {
///         let channel = FlutterMethodChannel(name: "flutter_image_downloader", binaryMessenger: registrar.messenger())
///         let instance = SwiftFlutterImageDownloaderPlugin()
///         registrar.addMethodCallDelegate(instance, channel: channel)
///     }
///
///     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
///         if call.method == "downloadImage" {
///             if let arguments = call.arguments as? [String: Any],
///                let imageUrl = arguments["imageUrl"] as? String , let path = arguments["path"] as? String{
///                 downloadImageAndSaveInGallery(imageUrl: URL(string: imageUrl)!, path: path)
///                 result(nil)
///             } else {
///                 result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
///             }
///         } else {
///             result(FlutterMethodNotImplemented)
///         }
///     }
///
///     private func downloadImageAndSaveInGallery(imageUrl: URL, path: String) {
///         let session = URLSession.shared
///         let task = session.dataTask(with: imageUrl) { data, response, error in
///             guard let data = data, error == nil else {
///                 print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
///                 return
///             }
///
///             if let image = UIImage(data: data) {
///                 // Save the image to the photo gallery
///                 PHPhotoLibrary.shared().performChanges({
///                     let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
///                     request.creationDate = Date()
///                 }, completionHandler: { success, error in
///                     if success {
///                         print("Image saved to gallery successfully. \(path)")
///                     } else {
///                         print("Error saving image to gallery: \(error?.localizedDescription ?? "Unknown error")")
///                     }
///                 })
///             }
///         }
///         task.resume()
///     }
/// }
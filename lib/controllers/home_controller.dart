import 'dart:async';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  EdScreenRecorder? screenRecorder;
  RxMap<String, dynamic>? response;
  RxBool isRecording = false.obs;
  RxInt resolutionWidth = 1920.obs;
  RxInt resolutionHeight = 1080.obs;
  RxInt videoFrame = 30.obs;
  RxInt videoBitrate = 3000000.obs;
  RxBool audioEnable = true.obs;

  RxString tempPath= ''.obs;

  @override
  void onInit() {
    super.onInit();
    response = RxMap<String, dynamic>().obs.value;
    screenRecorder = EdScreenRecorder();
  }

  Future<void> startRecord({required String fileName}) async {
    Directory? tempDir = await getDownloadsDirectory();
   tempPath.value = tempDir!.path;
    print(tempPath.value);
    try {
      RecordOutput startResponse = await screenRecorder!.startRecordScreen(
        fileName: fileName,
        dirPathToSave: tempPath.value,
        audioEnable: audioEnable.value,
        width: resolutionWidth.value,
        height: resolutionHeight.value,
        videoFrame: videoFrame.value,
        videoBitrate: videoBitrate.value,
      );

      response!.value = {
        'file': startResponse.file.path,
        'success': startResponse.success,
        'eventname': startResponse.eventName,
        'progressing': startResponse.isProgress,
        'message': startResponse.message,
        'videohash': startResponse.videoHash,
        'startdate': startResponse.startDate,
        'enddate': startResponse.endDate,
      };

      isRecording.value = true;
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
  }

  Future<void> stopRecord() async {
    try {
      RecordOutput stopResponse = await screenRecorder!.stopRecord();

      response!.value = {
        'file': stopResponse.file.path,
        'success': stopResponse.success,
        'eventname': stopResponse.eventName,
        'progressing': stopResponse.isProgress,
        'message': stopResponse.message,
        'videohash': stopResponse.videoHash,
        'startdate': stopResponse.startDate,
        'enddate': stopResponse.endDate,
      };

      isRecording.value = false;
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }
  }
}

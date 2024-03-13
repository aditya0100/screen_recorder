import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_recorder/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen Recorder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Video Resolution: ${controller.resolutionWidth} x ${controller.resolutionHeight}"),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: controller.resolutionWidth.toDouble(),
                      min: 640,
                      max: 3840,
                      divisions: 32,
                      onChanged: (value) {
                        controller.resolutionWidth.value = value.toInt();
                      },
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: controller.resolutionHeight.toDouble(),
                      min: 360,
                      max: 2160,
                      divisions: 18,
                      onChanged: (value) {
                        controller.resolutionHeight.value = value.toInt();
                      },
                    ),
                  ),
                ],
              ),
              Text("Frame Rate: ${controller.videoFrame} fps"),
              Slider(
                value: controller.videoFrame.toDouble(),
                min: 15,
                max: 60,
                divisions: 45,
                onChanged: (value) {
                  controller.videoFrame.value = value.toInt();
                },
              ),
              Text("Video Bitrate: ${controller.videoBitrate} kbps"),
              Slider(
                value: controller.videoBitrate.toDouble(),
                min: 100000,
                max: 10000000,
                divisions: 99,
                onChanged: (value) {
                  controller.videoBitrate.value = value.toInt();
                },
              ),
              Row(
                children: [
                  const Text("Audio: "),
                  Switch(
                    value: controller.audioEnable.value,
                    onChanged: (value) {
                      controller.audioEnable.value = value;
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: ElevatedButton(
                  style: controller.isRecording.value
                      ? const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white))
                      : const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    if (controller.isRecording.value) {
                      controller.stopRecord();
                    } else {
                      controller.startRecord(fileName: "my_recording");
                    }
                  },
                  child: Text(controller.isRecording.value
                      ? 'STOP RECORD'
                      : 'START RECORD'),
                ),
              ),
              SizedBox(height:Get.height*0.05),
              controller.tempPath.value!=''
                  ? Center(
                      child: Text(
                          'FInd recordings, path - ${controller.tempPath}'))
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    )
            ],
          ),
        ),
      ),
    );
  }
}

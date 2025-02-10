// video_call_widgets.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call_app/controller/video_call_controller.dart';

Widget buildLocalUserView(VideoCallController controller) {
  return Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 100,
      height: 150,
      child: controller.localUserJoined
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: controller.engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    ),
  );
}

// Widget buildRemoteUserLayout(VideoCallController controller, String channel) {
//   final remoteUids = controller.remoteUids;

//   if (remoteUids.isEmpty) {
//     return const Center(child: Text('Waiting for users...'));
//   }

//   return GridView.builder(
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       childAspectRatio: 1.0,
//     ),
//     itemCount: remoteUids.length,
//     itemBuilder: (context, index) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: controller.engine,
//           canvas: VideoCanvas(uid: remoteUids[index]),
//           connection: RtcConnection(channelId: channel),
//         ),
//       );
//     },
//   );
// }

Widget buildBeautySlider(VideoCallController controller) {
  return Positioned(
    bottom: 120,
    left: 20,
    right: 20,
    child: Column(
      children: [
        const Text("Beauty Filter Intensity"),
        Slider(
          activeColor: Colors.amber.shade200,
          value: controller.beautyIntensity,
          min: 0,
          max: 100,
          divisions: 10,
          label: controller.beautyIntensity.round().toString(),
          onChanged: controller.updateBeautyIntensity,
        ),
      ],
    ),
  );
}

Widget buildBottomAppBar(VideoCallController controller,BuildContext context) {
  return Positioned(
        bottom: 15,
        right: 20,
        left: 20,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade200),
          child: BottomAppBar(
            color: Colors.transparent, // Reduced opacity
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    controller.isMicMuted ? Icons.mic_off : Icons.mic,
                    color: Colors.black,
                  ),
                  onPressed: controller.toggleMic,
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.black),
                  onPressed: controller.switchCamera,
                ),
                IconButton(
                  icon: Icon(
                    Icons.photo_filter,
                    color: controller.isBeautyOn ? Colors.amber : Colors.black,
                  ),
                  onPressed: controller.applyBeauty,
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () => controller.endCall(context),
                ),
              ],
            ),
          ),
        ));
}

Widget buildRemoteUserLayout(VideoCallController controller,String channel) {
    final remoteUids = controller.remoteUids;

    if (remoteUids.isEmpty) {
      return const Center(child: Text('Waiting for users...'));
    }

    switch (remoteUids.length) {
      case 1:
        // Single remote user: full screen
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: controller.engine,
            canvas: VideoCanvas(uid: remoteUids[0]),
            connection: RtcConnection(channelId: channel),
          ),
        );
      case 2:
        // Two remote users: vertical split
        return Column(
          children: [
            Expanded(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: remoteUids[0]),
                  connection: RtcConnection(channelId: channel),
                ),
              ),
            ),
            Expanded(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: remoteUids[1]),
                  connection: RtcConnection(channelId: channel),
                ),
              ),
            ),
          ],
        );
      case 3:
        // Three remote users: top row with 2 users, bottom row with 1 user
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(uid: remoteUids[0]),
                        connection: RtcConnection(channelId: channel),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(uid: remoteUids[1]),
                        connection: RtcConnection(channelId: channel),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: remoteUids[2]),
                  connection: RtcConnection(channelId: channel),
                ),
              ),
            ),
          ],
        );
      default:
        // For 4 or more users: use a grid-like layout
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust as needed
            childAspectRatio: 1.0,
          ),
          itemCount: remoteUids.length,
          itemBuilder: (context, index) {
            return AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: controller.engine,
                canvas: VideoCanvas(uid: remoteUids[index]),
                connection: RtcConnection(channelId: channel),
              ),
            );
          },
        );
    }
  }

  


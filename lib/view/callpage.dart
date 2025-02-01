import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/video_call_controller.dart';

class VideoCallPage extends StatefulWidget {
  final String channel;
  final ClientRoleType role;

  const VideoCallPage({Key? key, required this.channel, required this.role})
      : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late VideoCallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoCallController();
  }

  @override
  Future<bool> _onWillPop() async {
    // Wait for the controller to be initialized before showing the dialog
    if (_controller != null) {
      bool shouldExit = await _showExitConfirmationDialog();
      return shouldExit;
    }
    return true; // Default action if the controller is not ready
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (!mounted) return false;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('End Call'),
              content: Text('Do you want to end the call or stay?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Don't exit, stay on the call
                  },
                  child: Text('Stay'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    if (mounted) {
                      _controller.endCall(context);
                    }
                  },
                  child: Text('End Call'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if no option is selected
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          VideoCallController()..initAgora(widget.channel, widget.role),
      child: Consumer<VideoCallController>(
        builder: (context, controller, child) {
          return Scaffold(
              appBar: AppBar(title: Text('Agora Video Call : ${widget.channel}')),
              body: Stack(
                children: [
                  _buildRemoteUserLayout(controller),
              //     Center(
              //   child: controller.remoteUids.isNotEmpty
              //       ? GridView.builder(
              //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2, // Adjust based on the number of users
              //             childAspectRatio: 1.0,
              //           ),
              //           itemCount: controller.remoteUids.length,
              //           itemBuilder: (context, index) {
              //             return AgoraVideoView(
              //               controller: VideoViewController.remote(
              //                 rtcEngine: controller.engine,
              //                 canvas: VideoCanvas(uid: controller.remoteUids[index]),
              //                 connection: RtcConnection(channelId: widget.channel),
              //               ),
              //             );
              //           },
              //         )
              //       : const Text('Waiting for users...'),
              // ),
                  Align(
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
                                    canvas: const VideoCanvas(uid: 0))),
                          )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  if (controller.isBeautyOn)
                    Positioned(
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
                            label:
                                controller.beautyIntensity.round().toString(),
                            onChanged: controller.updateBeautyIntensity,
                          ),
                        ],
                      ),
                    ),
                    Positioned(bottom: 15,right: 20,left:20, child: Container(
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
                              icon: const Icon(Icons.cameraswitch,
                                  color: Colors.black),
                              onPressed: controller.switchCamera,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.photo_filter,
                                color: controller.isBeautyOn
                                    ? Colors.amber
                                    : Colors.black,
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
                    ))
                ],
              ),
               );
        },
      ),
    );
  }
  // Helper method to build the dynamic layout for remote users
Widget _buildRemoteUserLayout(VideoCallController controller) {
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
          connection: RtcConnection(channelId: widget.channel),
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
                connection: RtcConnection(channelId: widget.channel),
              ),
            ),
          ),
          Expanded(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: controller.engine,
                canvas: VideoCanvas(uid: remoteUids[1]),
                connection: RtcConnection(channelId: widget.channel),
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
                      connection: RtcConnection(channelId: widget.channel),
                    ),
                  ),
                ),
                Expanded(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: controller.engine,
                      canvas: VideoCanvas(uid: remoteUids[1]),
                      connection: RtcConnection(channelId: widget.channel),
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
                connection: RtcConnection(channelId: widget.channel),
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
              connection: RtcConnection(channelId: widget.channel),
            ),
          );
        },
      );
  }
}

}


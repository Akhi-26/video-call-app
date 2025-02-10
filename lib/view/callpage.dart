import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_app/widgets/video_call_widgets.dart';

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

  Future<bool> _onWillPop() async {
      bool shouldExit = await _showExitConfirmationDialog();
      return shouldExit;
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
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              _onWillPop();
            },
            child: Scaffold(
              appBar: AppBar(title: Text('Agora Video Call : ${widget.channel}')),
              body: Stack(
                children: [
                  buildRemoteUserLayout(controller,widget.channel),
                  buildLocalUserView(controller),
                  if (controller.isBeautyOn) buildBeautySlider(controller),
                  buildBottomAppBar(controller, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

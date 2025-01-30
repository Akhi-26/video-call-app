import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../view/homepage.dart';

class AgoraService {
  late RtcEngine engine;

  Future<void> initializeAgora(String channel, ClientRoleType role,
      Function(int) onUserJoined, Function() onUserOffline) async {
    engine = await createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication));

    engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) =>
          onUserJoined(remoteUid),
      onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) =>
          onUserOffline(),
    ));

    await engine.enableVideo();
    await engine.startPreview();
    await engine.joinChannel(
      token: token,
      channelId: channel,
      options: ChannelMediaOptions(clientRoleType: role),
      uid: 0,
    );
  }

  void toggleMic(bool isMuted) {
    engine.muteLocalAudioStream(isMuted);
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
  }

  Future<void> updateBeautyEffect(bool isEnabled, double intensity) async {
    await engine.setBeautyEffectOptions(
      enabled: isEnabled,
      options: BeautyOptions(
        lighteningLevel: intensity / 100,
        smoothnessLevel: (intensity / 100) * 0.8,
        rednessLevel: (intensity / 100) * 0.5,
      ),
    );
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }
}

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../const.dart';
import '../view/homepage.dart';

class AgoraService {
  late RtcEngine engine;

  Future<void> initializeAgora(String channel, ClientRoleType role,
      Function(int) onUserJoined, Function(int) onUserOffline) async {
    engine = await createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
        appId: AgoraConstants.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication));

    engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) =>
          onUserJoined(remoteUid),
      onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) =>
          onUserOffline(remoteUid),
    ));

    await engine.enableVideo();

    // Enable low-latency mode
    await engine.setParameters("{\"che.video.lowLatencyStream\":true}");

    // Enable dual stream (low and high quality)
    await engine.enableDualStreamMode(enabled: true);

    // Enable FEC (Forward Error Correction) to handle packet loss
    await engine.setParameters("{\"rtc.enable_fec\":true}");

    // Enable audio optimization
    await engine.enableAudio();
    await engine.setAudioProfile( profile: 
      AudioProfileType.audioProfileSpeechStandard,  // Optimized for real-time communication
    );

    // Enable hardware acceleration for better performance
    await engine.setParameters("{\"rtc.video.hardware_acceleration\":true}");
    await engine.startPreview();
    await engine.joinChannel(
      token: AgoraConstants.token,
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

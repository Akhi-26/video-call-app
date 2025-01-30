import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/video_user.dart';
import '../service/agora_service.dart';

class VideoCallController extends ChangeNotifier {
  final VideoCallModel _model = VideoCallModel();
  final AgoraService _agoraService = AgoraService();

  RtcEngine get engine => _agoraService.engine;
  bool get isBeautyOn => _model.isBeautyOn;
  bool get isMicMuted => _model.isMicMuted;
  double get beautyIntensity => _model.beautyIntensity;
  bool get localUserJoined => _model.localUserJoined;
  int? get remoteUid => _model.remoteUid;

  Future<void> initAgora(String channel, ClientRoleType role) async {
    await [Permission.microphone, Permission.camera].request();
    await _agoraService.initializeAgora(
        channel, role, _onUserJoined, _onUserOffline);
    _model.localUserJoined = true;
    notifyListeners();
  }

  void _onUserJoined(int remoteUid) {
    _model.remoteUid = remoteUid;
    notifyListeners();
  }

  void _onUserOffline() {
    _model.remoteUid = null;
    notifyListeners();
  }

  void toggleMic() {
    _model.isMicMuted = !_model.isMicMuted;
    _agoraService.toggleMic(_model.isMicMuted);
    notifyListeners();
  }

  void switchCamera() async {
    await _agoraService.switchCamera();
  }

  void applyBeauty() {
    _model.isBeautyOn = !_model.isBeautyOn;
    _agoraService.updateBeautyEffect(_model.isBeautyOn, _model.beautyIntensity);
    notifyListeners();
  }

  void updateBeautyIntensity(double intensity) {
    _model.beautyIntensity = intensity;
    _agoraService.updateBeautyEffect(_model.isBeautyOn, intensity);
    notifyListeners();
  }

  Future<void> endCall(BuildContext context) async {
    await _agoraService.dispose();
    Navigator.pop(context);
  }
}

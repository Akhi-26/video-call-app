# video_call_app

📞 Agora Video Calling App


📌 Overview

Agora Video Calling App is a real-time video conferencing application built using Flutter and the Agora SDK. It allows users to create and join video calls by entering a channel name, selecting a role (Host/Audience), and enabling beauty filters. The app features a clean UI with a Lottie animation, Agora video integration, and customizable user settings.



🚀 Features

Real-time Beauty filter support with adjustable intensity

Real-time video calling using Agora SDK

Join calls by entering a channel name

Host or Audience mode selection

Mute/Unmute microphone

Switch camera (Front/Rear)

Dynamic token authentication

Smooth UI with animations



🛠️ Tech Stack

Flutter (Dart)

Agora RTC SDK

Lottie animations

Provider (State Management)


🎨 Real-Time Beauty Feature

The beauty filter feature is implemented using Agora's setBeautyEffectOptions method. When enabled, it applies real-time enhancements such as skin smoothing and lightening.

Slider for Intensity:

A Slider widget allows users to adjust the beauty effect intensity in real-time.

The intensity value updates dynamically, modifying the BeautyOptions applied to the video stream.

This ensures a seamless, real-time beauty effect without affecting performance.



🛑 Known Issues

Ensure the App ID and Token are correct.

Some devices may require Camera & Microphone permissions.
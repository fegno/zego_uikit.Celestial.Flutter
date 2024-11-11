// Dart imports:
import 'dart:async';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_express_engine/zego_express_engine.dart';

// Project imports:
import 'package:zego_uikit/src/services/internal/internal.dart';
import 'package:zego_uikit/src/services/services.dart';

mixin ZegoUIKitCoreDataScreenSharing {
  StreamController<List<ZegoUIKitCoreUser>>? screenSharingListStreamCtrl;

  ZegoScreenCaptureSource? screenCaptureSource;
  ValueNotifier<bool> isScreenSharing = ValueNotifier(false);
  ValueNotifier<bool> isScreenSharingQualityNormal = ValueNotifier(false);
  bool isFirstScreenSharing = true;

  void initScreenSharing() {
    ZegoLoggerService.logInfo(
      'init screen sharing',
      tag: 'uikit-screen-sharing',
      subTag: 'init',
    );

    screenSharingListStreamCtrl ??=
        StreamController<List<ZegoUIKitCoreUser>>.broadcast();
  }

  void uninitScreenSharing() {
    ZegoLoggerService.logInfo(
      'uninit screen sharing',
      tag: 'uikit-screen-sharing',
      subTag: 'uninit',
    );

    screenSharingListStreamCtrl?.close();
    screenSharingListStreamCtrl = null;
  }

  //start screen share
  Future<void> startSharingScreen() async {
    ZegoLoggerService.logInfo(
      'try start',
      tag: 'uikit-screen-sharing',
      subTag: 'startSharingScreen',
    );

    screenCaptureSource =
        await ZegoExpressEngine.instance.createScreenCaptureSource();

    await ZegoExpressEngine.instance
        .setVideoSource(
      ZegoVideoSourceType.ScreenCapture,
      instanceID: screenCaptureSource?.getIndex(),
      channel: ZegoStreamType.screenSharing.channel,
    )
        .then((value) {
      // flutter: onPublisherQualityUpdate 694_88037_screensharing quality:ZegoPublishStreamQualityExtension{videoCaptureFPS:0.0videoEncodeFPS:0.0videoSendFPS:0.0videoKBPS:0.0audioCaptureFPS:0.0audioSendFPS:0.0audioKBPS:0.0rtt:12packetLostRate:0.0level:ZegoStreamQualityLevel.ExcellentisHardwareEncode:truevideoCodecID:ZegoVideoCodecID.DefaulttotalSendBytes:5098682.0audioSendBytes:0.0videoSendByte:5098682.0}
      isScreenSharingQualityNormal.value = false;
      isScreenSharing.value = true;
      ZegoUIKitCore.shared.coreData
          .startPublishingStream(streamType: ZegoStreamType.screenSharing);
      final config = ZegoScreenCaptureConfig(
        true,
        true,
        microphoneVolume: 100,
        applicationVolume: 100,
      );
      screenCaptureSource?.startCapture(config: config);
    });

    if (isFirstScreenSharing && Platform.isAndroid) {
      isFirstScreenSharing = false;
      await stopSharingScreen();
      startSharingScreen();
    }

    ZegoLoggerService.logInfo(
      'start done',
      tag: 'uikit-screen-sharing',
      subTag: 'startSharingScreen',
    );
  }

  //stop screen share
  Future<void> stopSharingScreen() async {
    ZegoLoggerService.logInfo(
      'try stop',
      tag: 'uikit-screen-sharing',
      subTag: 'stopSharingScreen',
    );

    isScreenSharingQualityNormal.value = false;
    isScreenSharing.value = false;

    await ZegoUIKitCore.shared.coreData.stopPublishingStream(
      streamType: ZegoStreamType.screenSharing,
    );

    screenCaptureSource?.stopCapture();

    await ZegoExpressEngine.instance
        .destroyScreenCaptureSource(screenCaptureSource!);

    ZegoLoggerService.logInfo(
      'stop done',
      tag: 'uikit-screen-sharing',
      subTag: 'stopSharingScreen',
    );
  }
}

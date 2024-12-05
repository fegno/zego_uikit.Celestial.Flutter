// Project imports:
import 'dart:io';

import 'package:zego_uikit/src/channel/platform_interface.dart';
import 'package:zego_uikit/src/services/uikit_service.dart';

class ZegoUIKitReporterCommonParam {
  static String callKitName = "call";
  static String audioRoomKitName = "liveaudioroom";
  static String liveStreamingKitName = "livestreaming";
  static String imKitName = "imkit";

  String kitVersion;
  String kitName;

  ZegoUIKitReporterCommonParam({
    required this.kitVersion,
    required this.kitName,
  });

  Map<String, Object> toMap() {
    return {
      ZegoUIKitReporter.eventKeyKitVersion: kitVersion,
      ZegoUIKitReporter.eventKeyKitName: kitName,
    };
  }
}

class ZegoUIKitReporter {
  static String eventLoginRoom = "loginRoom";
  static String eventLogoutRoom = "logoutRoom";

  static String eventKeyRoomID = "room_id";
  static String eventKeyUserID = "user_id";
  static String eventKeyToken = "token";

  static String eventKeyErrorMsg = "msg";
  static String eventKeyErrorCode = "error";

  /// 事件开始时的时间戳，毫秒
  static String eventKeyStartTime = "start_time";

  /// 开发客户端应用的平台类型，例如 android、ios、flutter、rn、uniApp、web
  static String eventKeyPlatform = "platform";

  /// 平台版本，例如 rn 的 0.75.4，flutter 的 3.24
  static String eventKeyPlatformVersion = "platform_version";

  /// 平台版本，例如 rn 的 0.75.4，flutter 的 3.24
  static String eventKeyUIKitVersion = "uikit_version";

  /// 各个场景 kit 的版本号，通常为三段式
  static String eventKeyKitVersion = "kit_version";

  /// 场景 kit 的名称，通话为 call，直播为 livestreaming，语聊为 liveAudioRoom，聊天为 imkit
  static String eventKeyKitName = "kit_name";

  bool hadCreated = false;

  Future<void> create({
    required int appID,
    required String signOrToken,
    ZegoUIKitReporterCommonParam? commonParam,
    Map<String, Object> params = const {},
  }) async {
    params.addAll(commonParam?.toMap() ?? {});

    if (hadCreated) {
      ZegoLoggerService.logInfo(
        'had created before',
        tag: 'uikit-reporter',
        subTag: 'create',
      );

      if (params.isNotEmpty) {
        ZegoLoggerService.logInfo(
          'update common params',
          tag: 'uikit-reporter',
          subTag: 'create',
        );

        final uikitVersion = await ZegoUIKit().getZegoUIKitVersion();
        params.addAll({
          eventKeyPlatform: 'flutter',
          eventKeyUIKitVersion: uikitVersion,
        });
        updateCommonParams(params);
      }

      return;
    }

    ZegoLoggerService.logInfo(
      'create',
      tag: 'uikit-reporter',
      subTag: 'create',
    );
    hadCreated = true;

    final uikitVersion = await ZegoUIKit().getZegoUIKitVersion();
    params.addAll({
      eventKeyPlatform: 'flutter',
      eventKeyUIKitVersion: uikitVersion,
    });
    await ZegoUIKitPluginPlatform.instance.reporterCreate(
      appID: appID,
      signOrToken: signOrToken,
      params: params,
    );
  }

  Future<void> destroy() async {
    if (!hadCreated) {
      ZegoLoggerService.logInfo(
        'not created',
        tag: 'uikit-reporter',
        subTag: 'destroy',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      '',
      tag: 'uikit-reporter',
      subTag: 'destroy',
    );
    hadCreated = false;

    await ZegoUIKitPluginPlatform.instance.reporterDestroy();
  }

  Future<void> updateCommonParams(Map<String, Object> params) async {
    if (!hadCreated) {
      ZegoLoggerService.logInfo(
        'not init',
        tag: 'uikit-reporter',
        subTag: 'updateCommonParams',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      '$params',
      tag: 'uikit-reporter',
      subTag: 'updateCommonParams',
    );

    await ZegoUIKitPluginPlatform.instance.reporterUpdateCommonParams(params);
  }

  Future<void> updateUserID(String userID) async {
    if (!hadCreated) {
      ZegoLoggerService.logInfo(
        'not init',
        tag: 'uikit-reporter',
        subTag: 'updateUserID',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      '$userID',
      tag: 'uikit-reporter',
      subTag: 'updateUserID',
    );

    await ZegoUIKitPluginPlatform.instance.reporterUpdateCommonParams({
      eventKeyUserID: userID,
    });
  }

  Future<void> renewToken(String token) async {
    if (!hadCreated) {
      ZegoLoggerService.logInfo(
        'not init',
        tag: 'uikit-reporter',
        subTag: 'renewToken',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      'renew token, token size:${token.length}',
      tag: 'uikit-reporter',
      subTag: 'renewToken',
    );

    await ZegoUIKitPluginPlatform.instance.reporterUpdateToken(token);
  }

  Future<void> report({
    required String event,
    Map<String, Object> params = const {},
  }) async {
    if (!hadCreated) {
      ZegoLoggerService.logInfo(
        'not init',
        tag: 'uikit-reporter',
        subTag: 'report',
      );

      return;
    }

    await ZegoUIKitPluginPlatform.instance.reporterEvent(
      event: event,
      params: params,
    );
  }
}

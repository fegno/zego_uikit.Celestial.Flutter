// Project imports:
import 'package:flutter/cupertino.dart';

import 'package:zego_uikit/src/channel/platform_interface.dart';
import 'package:zego_uikit/src/services/uikit_service.dart';

class ZegoUIKitReporter {
  static String eventLoginRoom = "loginRoom";
  static String eventLogoutRoom = "logoutRoom";

  static String eventKeyRoomID = "room_id";
  static String eventKeyUserID = "user_id";
  static String eventKeyToken = "token";

  static String eventKeyErrorMsg = "msg";
  static String eventKeyErrorCode = "error";

  /// Timestamp at the start of the event, in milliseconds
  static String eventKeyStartTime = "start_time";

  /// Platform type for developing Client application, such as android, ios, flutter, rn, uniApp, web
  static String eventKeyPlatform = "platform";

  /// Platform version, such as rn 0.75.4, flutter 3.24
  static String eventKeyPlatformVersion = "platform_version";

  /// The underlying uikit version number that each kit depends on, usually in three segments
  static String eventKeyUIKitVersion = "uikit_version";

  /// Version number of each kit, usually in three segments
  static String eventKeyKitVersion = "kit_version";

  /// Name of kit, call for call, LIVE for livestreaming, voice chat for liveAudioRoom, chat for imkit
  static String eventKeyKitName = "kit_name";
  static String callKitName = "call";
  static String audioRoomKitName = "liveaudioroom";
  static String liveStreamingKitName = "livestreaming";
  static String imKitName = "imkit";

  static String eventKeyAppState = "app_state";
  static String eventKeyAppStateActive = "active";
  static String eventKeyAppStateBackground = "background";
  static String eventKeyAppStateRestarted = "restarted";

  static String currentAppState() {
    final appStateMap = <AppLifecycleState, String>{
      AppLifecycleState.resumed: eventKeyAppStateActive,
      AppLifecycleState.inactive: eventKeyAppStateBackground,
      AppLifecycleState.hidden: eventKeyAppStateBackground,
      AppLifecycleState.paused: eventKeyAppStateBackground,
      AppLifecycleState.detached: eventKeyAppStateBackground,
    };

    return appStateMap[WidgetsBinding.instance.lifecycleState] ??
        eventKeyAppStateBackground;
  }

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

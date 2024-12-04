// Project imports:
import 'package:zego_uikit/src/channel/platform_interface.dart';
import 'package:zego_uikit/src/services/uikit_service.dart';

class ZegoUIKitReporter {
  static String eventInit = "init";
  static String eventUninit = "unInit";
  static String eventLoginRoom = "loginRoom";
  static String eventLogoutRoom = "logoutRoom";

  static String eventKeyRoomID = "room_id";
  static String eventKeyErrorMsg = "msg";
  static String eventKeyErrorCode = "error";
  static String eventKeyUserID = "user_id";
  static String eventKeyStartTime = "start_time";
  static String eventKeyToken = "token";

  bool isInit = false;

  Future<void> init({
    required int appID,
    required String signOrToken,
    Map<String, Object> params = const {},
  }) async {
    if (isInit) {
      ZegoLoggerService.logInfo(
        'had init',
        tag: 'uikit-reporter',
        subTag: 'init',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      'init',
      tag: 'uikit-reporter',
      subTag: 'init',
    );
    isInit = true;

    await ZegoUIKitPluginPlatform.instance.reporterInit(
      appID: appID,
      signOrToken: signOrToken,
      userID: '_',
      params: params,
    );
  }

  Future<void> unInit() async {
    if (!isInit) {
      ZegoLoggerService.logInfo(
        'not init',
        tag: 'uikit-reporter',
        subTag: 'unInit',
      );

      return;
    }

    ZegoLoggerService.logInfo(
      '',
      tag: 'uikit-reporter',
      subTag: 'unInit',
    );
    isInit = false;

    await ZegoUIKitPluginPlatform.instance.reporterUnInit();
  }

  Future<void> renewToken(String token) async {
    if (!isInit) {
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
    if (!isInit) {
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

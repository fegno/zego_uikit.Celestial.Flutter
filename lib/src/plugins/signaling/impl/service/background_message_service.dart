// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

/// @nodoc
mixin ZegoPluginBackgroundMessageService {
  @pragma('vm:entry-point')
  Future<ZegoSignalingPluginSetMessageHandlerResult> setBackgroundMessageHandler(ZegoSignalingPluginZPNsBackgroundMessageHandler handler) async {
    return ZegoPluginAdapter().signalingPlugin!.setBackgroundMessageHandler(handler);
  }

  @pragma('vm:entry-point')
  Future<ZegoSignalingPluginSetMessageHandlerResult> setThroughMessageHandler(
    ZegoSignalingPluginZPNsThroughMessageHandler? handler,
  ) async {
    return ZegoPluginAdapter().signalingPlugin!.setThroughMessageHandler(handler);
  }
}

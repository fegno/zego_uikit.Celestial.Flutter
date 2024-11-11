part of 'uikit_service.dart';

mixin ZegoRoomService {
  bool get isRoomLogin => ZegoUIKitCore.shared.coreData.room.id.isNotEmpty;

  /// join room
  ///
  /// *[token]
  /// The token issued by the developer's business server is used to ensure security.
  /// For the generation rules, please refer to [Using Token Authentication] (https://doc-zh.zego.im/article/10360), the default is an empty string, that is, no authentication.
  ///
  /// if appSign is not passed in or if appSign is empty, this parameter must be set for authentication when logging in to a room.
  Future<ZegoRoomLoginResult> joinRoom(
    String roomID, {
    String token = '',
    bool markAsLargeRoom = false,
  }) async {
    final joinRoomResult = await ZegoUIKitCore.shared.joinRoom(
      roomID,
      token: token,
      markAsLargeRoom: markAsLargeRoom,
    );

    if (ZegoErrorCode.CommonSuccess != joinRoomResult.errorCode) {
      ZegoUIKitCore.shared.error.errorStreamCtrl?.add(ZegoUIKitError(
        code: ZegoUIKitErrorCode.roomLoginError,
        message: 'login room error:${joinRoomResult.errorCode}, '
            'room id:$roomID, large room:$markAsLargeRoom, '
            '${ZegoUIKitErrorCode.expressErrorCodeDocumentTips}',
        method: 'joinRoom',
      ));
    }

    return joinRoomResult;
  }

  /// leave room
  Future<ZegoRoomLogoutResult> leaveRoom({
    String? targetRoomID,
  }) async {
    final leaveRoomResult = await ZegoUIKitCore.shared.leaveRoom(
      targetRoomID: targetRoomID,
    );

    if (ZegoErrorCode.CommonSuccess != leaveRoomResult.errorCode) {
      ZegoUIKitCore.shared.error.errorStreamCtrl?.add(ZegoUIKitError(
        code: ZegoUIKitErrorCode.roomLeaveError,
        message: 'leave room error:${leaveRoomResult.errorCode}, '
            '${ZegoUIKitErrorCode.expressErrorCodeDocumentTips}',
        method: 'leaveRoom',
      ));
    }

    return leaveRoomResult;
  }

  Future<void> renewRoomToken(String token) async {
    await ZegoUIKitCore.shared.renewRoomToken(token);
  }

  /// get room object
  ZegoUIKitRoom getRoom() {
    return ZegoUIKitCore.shared.coreData.room.toUIKitRoom();
  }

  /// get room state notifier
  ValueNotifier<ZegoUIKitRoomState> getRoomStateStream() {
    return ZegoUIKitCore.shared.coreData.room.state;
  }

  /// update one room property
  Future<bool> setRoomProperty(String key, String value) async {
    return ZegoUIKitCore.shared.setRoomProperty(key, value);
  }

  /// update room properties
  Future<bool> updateRoomProperties(Map<String, String> properties) async {
    return ZegoUIKitCore.shared
        .updateRoomProperties(Map<String, String>.from(properties));
  }

  /// get room properties
  Map<String, RoomProperty> getRoomProperties() {
    return Map<String, RoomProperty>.from(
        ZegoUIKitCore.shared.coreData.room.properties);
  }

  /// only notify the property which changed
  /// you can get full properties by getRoomProperties() function
  Stream<RoomProperty> getRoomPropertyStream() {
    return ZegoUIKitCore.shared.coreData.room.propertyUpdateStream?.stream ??
        const Stream.empty();
  }

  /// the room Token authentication is about to expire will be sent 30 seconds before the Token expires
  Stream<int> getRoomTokenExpiredStream() {
    return ZegoUIKitCore.shared.coreData.room.tokenExpiredStreamCtrl?.stream ??
        const Stream.empty();
  }

  /// only notify the properties which changed
  /// you can get full properties by getRoomProperties() function
  Stream<Map<String, RoomProperty>> getRoomPropertiesStream() {
    return ZegoUIKitCore.shared.coreData.room.propertiesUpdatedStream?.stream ??
        const Stream.empty();
  }

  /// get network state notifier
  Stream<ZegoNetworkMode> getNetworkModeStream() {
    return ZegoUIKitCore.shared.coreData.networkModeStreamCtrl?.stream ??
        const Stream.empty();
  }
}

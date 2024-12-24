// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_uikit/src/services/uikit_service.dart';
import 'package:zego_uikit/src/services/defines/network.dart';

class ZegoNetworkLoading extends StatefulWidget {
  const ZegoNetworkLoading({
    Key? key,
    required this.child,
    this.enabled = true,
    this.icon,
    this.iconColor,
    this.progressColor,
  }) : super(key: key);

  final Widget child;
  final bool enabled;

  /// icon when network had error
  final Widget? icon;
  final Color? iconColor;
  final Color? progressColor;

  @override
  State<ZegoNetworkLoading> createState() => _ZegoNetworkLoadingState();
}

class _ZegoNetworkLoadingState extends State<ZegoNetworkLoading> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZegoUIKitNetworkState>(
      valueListenable: ZegoUIKit().getNetworkStateNotifier(),
      builder: (context, networkState, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.child,
            if (widget.enabled) ...loading(networkState),
          ],
        );
      },
    );
  }

  List<Widget> loading(ZegoUIKitNetworkState networkState) {
    return ZegoUIKitNetworkState.online == networkState
        ? []
        : [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  (widget.progressColor ?? Colors.black).withOpacity(0.2)),
            ),
            widget.icon ??
                Icon(
                  Icons.wifi_off,
                  color: (widget.iconColor ?? Colors.black).withOpacity(0.5),
                ),
          ];
  }
}

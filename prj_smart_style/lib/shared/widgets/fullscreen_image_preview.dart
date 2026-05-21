import 'package:flutter/material.dart';

class FullscreenImagePreview extends StatelessWidget {
  final Widget child;
  final Widget fullscreenChild;
  final Color barrierColor;

  const FullscreenImagePreview({
    super.key,
    required this.child,
    required this.fullscreenChild,
    this.barrierColor = Colors.black,
  });

  void _openPreview(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: barrierColor,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(child: fullscreenChild),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openPreview(context);
      },
      child: child,
    );
  }
}

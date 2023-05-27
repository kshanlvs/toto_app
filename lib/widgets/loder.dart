import 'package:flutter/material.dart';
import 'package:toto_app/color_constants.dart';

class OrangeLoaderOverlay {
  static OverlayEntry? _overlayEntry;
  static void show(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: OrangeLoader(),
          ),
        );
      },
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class OrangeLoader extends StatelessWidget {
  final double size;
  final Color color;
  const OrangeLoader({Key? key, this.size = 40.0, this.color = primaryColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

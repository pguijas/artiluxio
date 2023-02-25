import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloattingButton extends StatelessWidget {
  ValueNotifier<bool> isDialOpen;
  Function onCamera;
  Function onGallery;

  FloattingButton(
      {required this.isDialOpen,
      required this.onCamera,
      required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).colorScheme.primary, // primary swatch
      animatedIcon: AnimatedIcons.menu_arrow,
      label: const Text("New Inference"),
      renderOverlay: true,
      spacing: 10,
      spaceBetweenChildren: 10,
      switchLabelPosition: true,
      openCloseDial: isDialOpen,

      children: [
        SpeedDialChild(
          child: const Icon(Icons.camera_alt),
          label: "Camera",
          onTap: () => onCamera(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_photo_alternate),
          label: "Gallery",
          onTap: () => onGallery(),
        ),
      ],
    );
  }
}

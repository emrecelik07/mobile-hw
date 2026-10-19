import 'package:flutter/material.dart';

import '../models/campus_event.dart';

/// Full-screen view of an event image. Pinch to zoom further.
class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(event.title),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 4,
          child: Hero(
            tag: 'event-image-${event.id}',
            child: Image.asset(
              event.imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

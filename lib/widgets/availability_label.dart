import 'package:flutter/material.dart';

import '../models/campus_event.dart';

/// Shows how many places are left, or "Full" for an unjoined event with no
/// available place.
class AvailabilityLabel extends StatelessWidget {
  const AvailabilityLabel({
    super.key,
    required this.event,
    required this.isJoined,
  });

  final CampusEvent event;
  final bool isJoined;

  @override
  Widget build(BuildContext context) {
    final available = event.availablePlaces;
    final String text;
    final Color background;
    final Color foreground;

    if (available == 0) {
      text = isJoined ? 'No places left' : 'Full';
      background = const Color(0xFFFDE2E1);
      foreground = const Color(0xFFB3261E);
    } else if (available == 1) {
      text = '1 place left';
      background = const Color(0xFFFFE8CC);
      foreground = const Color(0xFF8A4B00);
    } else {
      text = '$available of ${event.totalCapacity} places left';
      background = const Color(0xFFDDF4E2);
      foreground = const Color(0xFF1B5E20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

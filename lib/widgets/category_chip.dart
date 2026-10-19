import 'package:flutter/material.dart';

import '../models/campus_event.dart';

/// Icon and color used to represent each category in the UI.
extension EventCategoryStyle on EventCategory {
  IconData get icon => switch (this) {
    EventCategory.technology => Icons.memory,
    EventCategory.arts => Icons.palette,
    EventCategory.sports => Icons.sports_soccer,
  };

  Color get color => switch (this) {
    EventCategory.technology => const Color(0xFF3949AB),
    EventCategory.arts => const Color(0xFFC2185B),
    EventCategory.sports => const Color(0xFF2E7D32),
  };
}

/// A small pill showing an event's category with its icon.
class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category});

  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    final color = category.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

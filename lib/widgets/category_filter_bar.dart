import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import 'category_chip.dart';

/// Horizontal list of choice chips: "All" plus one chip per category.
///
/// A `null` selection means "All".
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final category in EventCategory.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              avatar: Icon(category.icon, size: 18),
              label: Text(category.label),
              selected: selected == category,
              onSelected: (_) => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}

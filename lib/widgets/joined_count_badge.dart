import 'package:flutter/material.dart';

/// Shows the total number of joined events, e.g. in the app bar.
class JoinedCountBadge extends StatelessWidget {
  const JoinedCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_available,
            size: 18,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            'Joined: $count',
            style: TextStyle(
              color: colors.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

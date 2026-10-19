import 'package:flutter/material.dart';

/// A small "Joined" marker shown on events the student participates in.
class JoinedChip extends StatelessWidget {
  const JoinedChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: colors.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            'Joined',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

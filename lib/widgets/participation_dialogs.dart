import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/date_time_format.dart';

/// Asks the student to confirm joining [event].
///
/// Returns `true` only when "Yes" is pressed. "No" or dismissing the dialog
/// returns `false`.
Future<bool> showJoinConfirmationDialog(
  BuildContext context,
  CampusEvent event,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Join this event?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _DialogInfoRow(
            icon: Icons.schedule,
            text: formatEventDateTime(event.dateTime),
          ),
          const SizedBox(height: 6),
          _DialogInfoRow(icon: Icons.place_outlined, text: event.venue),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Asks the student to confirm cancelling participation in [event].
///
/// Returns `true` only when "Yes" is pressed.
Future<bool> showCancelParticipationDialog(
  BuildContext context,
  CampusEvent event,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel participation?'),
      content: Text(
        'Do you want to cancel your participation in "${event.title}"? '
        'Your place will be released for other students.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class _DialogInfoRow extends StatelessWidget {
  const _DialogInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

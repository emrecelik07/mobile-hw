import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/date_time_format.dart';
import 'availability_label.dart';
import 'category_chip.dart';
import 'favorite_button.dart';
import 'joined_chip.dart';

/// A reusable card that summarizes one event in a list.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.isJoined,
    required this.onFavoritePressed,
    required this.onOpenDetails,
  });

  final CampusEvent event;
  final bool isFavorite;
  final bool isJoined;
  final VoidCallback onFavoritePressed;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onOpenDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(event.imagePath, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onFavoritePressed,
                    filledBackground: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      CategoryChip(category: event.category),
                      AvailabilityLabel(event: event, isJoined: isJoined),
                      if (isJoined) const JoinedChip(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _IconText(
                    icon: Icons.schedule,
                    text: formatEventDateTime(event.dateTime),
                  ),
                  const SizedBox(height: 4),
                  _IconText(icon: Icons.place_outlined, text: event.venue),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onOpenDetails,
                  icon: const Icon(Icons.arrow_forward),
                  iconAlignment: IconAlignment.end,
                  label: const Text('View details'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

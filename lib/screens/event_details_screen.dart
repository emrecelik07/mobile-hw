import 'package:flutter/material.dart';

import '../logic/event_manager.dart';
import '../models/campus_event.dart';
import '../utils/date_time_format.dart';
import '../widgets/availability_label.dart';
import '../widgets/category_chip.dart';
import '../widgets/favorite_button.dart';
import '../widgets/joined_chip.dart';
import '../widgets/participation_dialogs.dart';
import 'image_viewer_screen.dart';

/// Shows all information about one event, with favorite and participation
/// controls. Double-tapping the image opens [ImageViewerScreen].
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.manager,
    required this.onChanged,
  });

  final CampusEvent event;
  final EventManager manager;

  /// Called after every change so the previous screen updates as well.
  final VoidCallback onChanged;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  CampusEvent get _event => widget.event;
  EventManager get _manager => widget.manager;

  void _update(VoidCallback change) {
    setState(change);
    widget.onChanged();
  }

  void _toggleFavorite() {
    _update(() => _manager.toggleFavorite(_event));
  }

  Future<void> _join() async {
    final confirmed = await showJoinConfirmationDialog(context, _event);
    if (!confirmed || !mounted) return;

    var joined = false;
    _update(() => joined = _manager.join(_event));
    _showFeedback(
      joined
          ? 'You joined "${_event.title}". It is now in My Events.'
          : 'This event could not be joined.',
    );
  }

  Future<void> _cancelParticipation() async {
    final confirmed = await showCancelParticipationDialog(context, _event);
    if (!confirmed || !mounted) return;

    var cancelled = false;
    _update(() => cancelled = _manager.cancelParticipation(_event));
    if (cancelled) {
      _showFeedback('Your participation in "${_event.title}" was cancelled.');
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openImageViewer() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ImageViewerScreen(event: _event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isJoined = _manager.isJoined(_event);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          FavoriteButton(
            isFavorite: _manager.isFavorite(_event),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: ListView(
        children: [
          GestureDetector(
            onDoubleTap: _openImageViewer,
            child: Hero(
              tag: 'event-image-${_event.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(_event.imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.zoom_in,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Double-tap the image to enlarge it',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    CategoryChip(category: _event.category),
                    AvailabilityLabel(event: _event, isJoined: isJoined),
                    if (isJoined) const JoinedChip(),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _event.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  icon: Icons.schedule,
                  label: 'Date and time',
                  value: formatEventDateTime(_event.dateTime),
                ),
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: 'Venue',
                  value: _event.venue,
                ),
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Category',
                  value: _event.category.label,
                ),
                _InfoRow(
                  icon: Icons.groups_outlined,
                  label: 'Total capacity',
                  value: '${_event.totalCapacity} places',
                ),
                _InfoRow(
                  icon: Icons.event_seat_outlined,
                  label: 'Available places',
                  value: '${_event.availablePlaces}',
                ),
                _InfoRow(icon: Icons.tag, label: 'Event ID', value: _event.id),
                const SizedBox(height: 8),
                Text(
                  'About this event',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(_event.description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _buildParticipationButton(isJoined),
        ),
      ),
    );
  }

  Widget _buildParticipationButton(bool isJoined) {
    final style = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
    );
    if (isJoined) {
      return FilledButton.tonalIcon(
        style: style,
        onPressed: _cancelParticipation,
        icon: const Icon(Icons.event_busy),
        label: const Text('Cancel participation'),
      );
    }
    if (_manager.isFull(_event)) {
      return FilledButton.icon(
        style: style,
        onPressed: null,
        icon: const Icon(Icons.block),
        label: const Text('Full - cannot join'),
      );
    }
    return FilledButton.icon(
      style: style,
      onPressed: _join,
      icon: const Icon(Icons.event_available),
      label: const Text('Join event'),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

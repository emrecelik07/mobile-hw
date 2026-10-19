import '../models/campus_event.dart';

/// Holds the in-memory state of one app session: the events, the favorites
/// and the events the student has joined.
///
/// This is a plain Dart class. Widgets call its methods inside `setState`, so
/// no state-management library is needed. Nothing is persisted; favorites and
/// participation reset when the app restarts.
class EventManager {
  EventManager(List<CampusEvent> events) : events = List.unmodifiable(events);

  final List<CampusEvent> events;
  final Set<String> _favoriteIds = {};
  final Set<String> _joinedIds = {};

  List<CampusEvent> get favoriteEvents => events.where(isFavorite).toList();

  List<CampusEvent> get joinedEvents => events.where(isJoined).toList();

  /// Total number of events the student has joined.
  int get joinedCount => _joinedIds.length;

  bool isFavorite(CampusEvent event) => _favoriteIds.contains(event.id);

  bool isJoined(CampusEvent event) => _joinedIds.contains(event.id);

  /// An event is "Full" for this student when it has no available place and
  /// the student has not joined it.
  bool isFull(CampusEvent event) =>
      !isJoined(event) && !event.hasAvailablePlaces;

  bool canJoin(CampusEvent event) =>
      !isJoined(event) && event.hasAvailablePlaces;

  /// Adds or removes a favorite. Never changes participation or capacity.
  void toggleFavorite(CampusEvent event) {
    if (!_favoriteIds.remove(event.id)) {
      _favoriteIds.add(event.id);
    }
  }

  /// Joins [event] once and takes one available place.
  ///
  /// Returns `false` (and changes nothing) if the event is already joined or
  /// has no available place, so repeated joins never create duplicates or
  /// decrease the capacity twice.
  bool join(CampusEvent event) {
    if (!canJoin(event)) return false;
    event.takePlace();
    _joinedIds.add(event.id);
    return true;
  }

  /// Cancels participation and restores one available place.
  ///
  /// Returns `false` (and changes nothing) if the event was not joined.
  bool cancelParticipation(CampusEvent event) {
    if (!_joinedIds.remove(event.id)) return false;
    event.releasePlace();
    return true;
  }

  /// Returns the events of [source] whose title contains [query] and which
  /// belong to [category] (`null` means all categories).
  ///
  /// The title search ignores letter case and surrounding spaces.
  static List<CampusEvent> filter(
    List<CampusEvent> source, {
    String query = '',
    EventCategory? category,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return source.where((event) {
      final matchesCategory = category == null || event.category == category;
      final matchesTitle =
          normalizedQuery.isEmpty ||
          event.title.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesTitle;
    }).toList();
  }
}

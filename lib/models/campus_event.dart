/// The categories a campus event can belong to.
enum EventCategory {
  technology('Technology'),
  arts('Arts'),
  sports('Sports');

  const EventCategory(this.label);

  /// Human-readable name shown in the UI.
  final String label;
}

/// A single campus event with its capacity information.
///
/// All fields are fixed except [availablePlaces], which changes when a
/// student joins or cancels participation. It is always kept between zero
/// and [totalCapacity].
class CampusEvent {
  CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imagePath,
    required this.totalCapacity,
    required int availablePlaces,
  }) : assert(totalCapacity > 0, 'Total capacity must be positive.'),
       assert(
         availablePlaces >= 0 && availablePlaces <= totalCapacity,
         'Available places must be between 0 and total capacity.',
       ),
       _availablePlaces = availablePlaces;

  final String id;
  final String title;
  final EventCategory category;
  final DateTime dateTime;
  final String venue;
  final String description;

  /// Path of the bundled image asset, e.g. `assets/images/tech_hackathon.png`.
  final String imagePath;

  final int totalCapacity;
  int _availablePlaces;

  int get availablePlaces => _availablePlaces;

  bool get hasAvailablePlaces => _availablePlaces > 0;

  /// Takes one place. Returns `false` if no place is available.
  bool takePlace() {
    if (_availablePlaces <= 0) return false;
    _availablePlaces--;
    return true;
  }

  /// Releases one place. Returns `false` if the event is already empty.
  bool releasePlace() {
    if (_availablePlaces >= totalCapacity) return false;
    _availablePlaces++;
    return true;
  }
}

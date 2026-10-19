import 'package:campus_event_explorer/logic/event_manager.dart';
import 'package:campus_event_explorer/models/campus_event.dart';
import 'package:flutter_test/flutter_test.dart';

CampusEvent _event({
  String id = 'T1',
  String title = 'Test Event',
  EventCategory category = EventCategory.technology,
  int total = 10,
  int available = 5,
}) {
  return CampusEvent(
    id: id,
    title: title,
    category: category,
    dateTime: DateTime(2026, 11, 1, 10),
    venue: 'Test Hall',
    description: 'Test description',
    imagePath: 'assets/images/tech_hackathon.png',
    totalCapacity: total,
    availablePlaces: available,
  );
}

void main() {
  group('Join and cancel participation', () {
    test('joining decreases available places by one and only once', () {
      final event = _event(available: 5);
      final manager = EventManager([event]);

      expect(manager.join(event), isTrue);
      expect(event.availablePlaces, 4);
      expect(manager.joinedCount, 1);

      // Joining the same event again must not change anything.
      expect(manager.join(event), isFalse);
      expect(event.availablePlaces, 4);
      expect(manager.joinedCount, 1);
      expect(manager.joinedEvents, [event]);
    });

    test('cancelling restores one place and removes it from My Events', () {
      final event = _event(available: 5);
      final manager = EventManager([event]);

      manager.join(event);
      expect(manager.cancelParticipation(event), isTrue);
      expect(event.availablePlaces, 5);
      expect(manager.joinedEvents, isEmpty);
      expect(manager.joinedCount, 0);

      // Cancelling an event that is not joined changes nothing.
      expect(manager.cancelParticipation(event), isFalse);
      expect(event.availablePlaces, 5);
    });

    test('an unjoined event with zero places is Full and cannot be joined', () {
      final event = _event(available: 0);
      final manager = EventManager([event]);

      expect(manager.isFull(event), isTrue);
      expect(manager.canJoin(event), isFalse);
      expect(manager.join(event), isFalse);
      expect(event.availablePlaces, 0);
      expect(manager.joinedCount, 0);
    });

    test('a student who took the last place can still cancel', () {
      final event = _event(available: 1);
      final manager = EventManager([event]);

      expect(manager.join(event), isTrue);
      expect(event.availablePlaces, 0);
      expect(manager.isFull(event), isFalse, reason: 'joined, so not "Full"');

      expect(manager.cancelParticipation(event), isTrue);
      expect(event.availablePlaces, 1);
    });

    test('favorites do not change participation or capacity', () {
      final event = _event(available: 3);
      final manager = EventManager([event]);

      manager.toggleFavorite(event);
      expect(manager.isFavorite(event), isTrue);
      expect(manager.favoriteEvents, [event]);
      expect(event.availablePlaces, 3);
      expect(manager.isJoined(event), isFalse);

      manager.toggleFavorite(event);
      expect(manager.favoriteEvents, isEmpty);
    });
  });

  group('Search and category filter', () {
    final events = [
      _event(id: 'A', title: 'Flutter Hackathon'),
      _event(id: 'B', title: 'Jazz Night', category: EventCategory.arts),
      _event(id: 'C', title: 'Fun Run', category: EventCategory.sports),
    ];

    test('title search ignores case and surrounding spaces', () {
      final result = EventManager.filter(events, query: '   fLUTTER  ');
      expect(result.map((e) => e.id), ['A']);
    });

    test('empty query with no category returns every event', () {
      expect(EventManager.filter(events, query: '   '), events);
    });

    test('search and category work together', () {
      expect(
        EventManager.filter(
          events,
          query: 'n',
          category: EventCategory.arts,
        ).map((e) => e.id),
        ['B'],
      );
      expect(
        EventManager.filter(
          events,
          query: 'jazz',
          category: EventCategory.sports,
        ),
        isEmpty,
      );
    });
  });
}

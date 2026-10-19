import 'dart:io';

import 'package:campus_event_explorer/data/sample_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final events = createSampleEvents();

  test('there are at least six events in at least three categories', () {
    expect(events.length, greaterThanOrEqualTo(6));
    expect(
      events.map((e) => e.category).toSet().length,
      greaterThanOrEqualTo(3),
    );
  });

  test('event IDs are unique', () {
    expect(events.map((e) => e.id).toSet().length, events.length);
  });

  test('one event is initially full and one has exactly one place', () {
    expect(events.where((e) => e.availablePlaces == 0), isNotEmpty);
    expect(events.where((e) => e.availablePlaces == 1), isNotEmpty);
  });

  test('available places are between zero and total capacity', () {
    for (final event in events) {
      expect(event.availablePlaces, inInclusiveRange(0, event.totalCapacity));
    }
  });

  test('all dates are after the assignment deadline', () {
    // October 25, 2026, 23:59 UTC+3.
    final deadline = DateTime.utc(2026, 10, 25, 20, 59);
    for (final event in events) {
      expect(event.dateTime.isAfter(deadline), isTrue, reason: event.title);
    }
  });

  test('at least three distinct local images exist on disk', () {
    final paths = events.map((e) => e.imagePath).toSet();
    expect(paths.length, greaterThanOrEqualTo(3));
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}

import 'package:campus_event_explorer/app.dart';
import 'package:campus_event_explorer/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps the app on a phone-sized screen.
Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const CampusEventExplorerApp());
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pumpAndSettle();
}

Future<void> _openFirstDetails(WidgetTester tester) async {
  await tester.tap(find.text('View details').first);
  await tester.pumpAndSettle();
}

/// Lets any visible snack bar time out so no timers stay pending.
Future<void> _settleSnackBars(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Explore shows all events and the matching count', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('Campus Events'), findsOneWidget);
    expect(find.text('8 matching events'), findsOneWidget);
    expect(find.text('Joined: 0'), findsOneWidget);
    expect(find.text('Flutter Hackathon 2026'), findsOneWidget);
  });

  testWidgets('Search ignores case and spaces and works with categories', (
    tester,
  ) async {
    await _pumpApp(tester);

    await _search(tester, '   fLuTtEr HACKATHON  ');
    expect(find.text('1 matching event'), findsOneWidget);
    expect(find.text('Flutter Hackathon 2026'), findsOneWidget);

    await _search(tester, 'run');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Sports'));
    await tester.pumpAndSettle();
    expect(find.text('1 matching event'), findsOneWidget);
    expect(find.text('Campus 5K Fun Run'), findsOneWidget);

    // "run" in Technology matches nothing: readable empty state.
    await tester.tap(find.widgetWithText(ChoiceChip, 'Technology'));
    await tester.pumpAndSettle();
    expect(find.text('0 matching events'), findsOneWidget);
    expect(find.text('No events match your search'), findsOneWidget);

    // Clearing the search keeps the category filter.
    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('3 matching events'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.text('8 matching events'), findsOneWidget);
  });

  testWidgets('The clear icon in the search field resets the search', (
    tester,
  ) async {
    await _pumpApp(tester);

    await _search(tester, 'zzz');
    expect(find.text('No events match your search'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('8 matching events'), findsOneWidget);
  });

  testWidgets('A full event is marked Full and cannot be joined', (
    tester,
  ) async {
    await _pumpApp(tester);

    await _search(tester, 'AI in Everyday');
    expect(find.text('Full'), findsOneWidget);

    await _openFirstDetails(tester);
    expect(find.text('Full - cannot join'), findsOneWidget);
    expect(find.text('Join event'), findsNothing);
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Full - cannot join'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets(
    'Join: No/dismiss change nothing, Yes joins the last place once',
    (tester) async {
      await _pumpApp(tester);

      await _search(tester, 'painting');
      expect(find.text('1 place left'), findsOneWidget);
      await _openFirstDetails(tester);

      // "No" leaves the data unchanged.
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      expect(find.text('Join this event?'), findsOneWidget);
      expect(find.text('Sun, 15 Nov 2026 · 11:00'), findsWidgets);
      expect(find.text('Botanical Garden Pavilion'), findsWidgets);
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      expect(find.text('1 place left'), findsOneWidget);
      expect(find.text('Join event'), findsOneWidget);

      // Dismissing the dialog also leaves the data unchanged.
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Join this event?'), findsNothing);
      expect(find.text('1 place left'), findsOneWidget);

      // "Yes" joins and takes the last place.
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.textContaining('You joined'), findsOneWidget);
      expect(find.text('No places left'), findsOneWidget);
      expect(find.text('Cancel participation'), findsOneWidget);
      expect(find.text('Join event'), findsNothing);

      // Back on Explore, the card and the joined counter are updated.
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Joined: 1'), findsOneWidget);
      expect(find.text('Joined'), findsOneWidget);
      await _settleSnackBars(tester);
    },
  );

  testWidgets('Cancel participation with confirmation updates My Events', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();
    expect(find.text('You have not joined any events yet'), findsOneWidget);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await _search(tester, 'painting');
    await _openFirstDetails(tester);
    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await _settleSnackBars(tester);

    // The same search applies to My Events.
    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();
    expect(find.text('Open Air Painting Workshop'), findsOneWidget);
    expect(find.text('1 matching event'), findsOneWidget);

    await _openFirstDetails(tester);
    await tester.tap(find.text('Cancel participation'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel participation?'), findsOneWidget);

    // "No" keeps the participation.
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel participation'), findsOneWidget);

    // "Yes" cancels and restores the place.
    await tester.tap(find.text('Cancel participation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.text('Join event'), findsOneWidget);
    expect(find.text('1 place left'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('You have not joined any events yet'), findsOneWidget);
    expect(find.text('Joined: 0'), findsOneWidget);
    await _settleSnackBars(tester);
  });

  testWidgets('Favorites from a card and from details update all views', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorite events yet'), findsOneWidget);

    // Add a favorite from a card on Explore.
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites').last);
    await tester.pumpAndSettle();
    expect(find.text('1 matching event'), findsOneWidget);
    expect(find.text('Flutter Hackathon 2026'), findsOneWidget);

    // Remove it from the details screen; Favorites updates after Back.
    await _openFirstDetails(tester);
    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Add to favorites'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('No favorite events yet'), findsOneWidget);
    expect(find.text('Joined: 0'), findsOneWidget);
  });

  testWidgets('Double-tapping the details image opens the image viewer', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openFirstDetails(tester);

    final image = find.byType(Hero);
    await tester.tap(image);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(image);
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ImageViewerScreen), findsNothing);
    expect(find.text('Event Details'), findsOneWidget);
  });
}

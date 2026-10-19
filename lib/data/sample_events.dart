import '../models/campus_event.dart';

/// Creates a fresh list of fictional campus events.
///
/// The data lives in Dart code so the app works without any online service.
/// A new list is returned on every call, so each app session starts from the
/// same initial capacities.
List<CampusEvent> createSampleEvents() {
  return [
    CampusEvent(
      id: 'E01',
      title: 'Flutter Hackathon 2026',
      category: EventCategory.technology,
      dateTime: DateTime(2026, 11, 7, 10, 0),
      venue: 'Engineering Faculty, Lab B-204',
      description:
          'A 10-hour team hackathon where students build a small mobile app '
          'with Flutter. Mentors will be available all day, and the three best '
          'projects will be presented at the closing session. Bring your own '
          'laptop with the Flutter SDK installed.',
      imagePath: 'assets/images/tech_hackathon.png',
      totalCapacity: 40,
      availablePlaces: 12,
    ),
    CampusEvent(
      id: 'E02',
      title: 'AI in Everyday Life Talk',
      category: EventCategory.technology,
      dateTime: DateTime(2026, 11, 12, 14, 30),
      venue: 'Main Conference Hall',
      description:
          'An introductory talk on how artificial intelligence is used in '
          'everyday tools such as maps, translators and recommendation '
          'systems, followed by a short Q&A session with the speakers.',
      imagePath: 'assets/images/tech_ai_talk.png',
      totalCapacity: 120,
      availablePlaces: 0,
    ),
    CampusEvent(
      id: 'E03',
      title: 'Open Air Painting Workshop',
      category: EventCategory.arts,
      dateTime: DateTime(2026, 11, 15, 11, 0),
      venue: 'Botanical Garden Pavilion',
      description:
          'Learn the basics of landscape painting outdoors. Brushes, paints '
          'and canvases are provided. No previous experience is needed; the '
          'workshop is limited to a small group so everyone gets feedback.',
      imagePath: 'assets/images/arts_painting.png',
      totalCapacity: 20,
      availablePlaces: 1,
    ),
    CampusEvent(
      id: 'E04',
      title: 'Autumn Jazz Night',
      category: EventCategory.arts,
      dateTime: DateTime(2026, 11, 21, 19, 30),
      venue: 'Culture and Arts Center Stage',
      description:
          'The student jazz ensemble performs classic standards and original '
          'compositions. Doors open 30 minutes before the concert. Free '
          'entry for registered students.',
      imagePath: 'assets/images/arts_music.png',
      totalCapacity: 150,
      availablePlaces: 64,
    ),
    CampusEvent(
      id: 'E05',
      title: 'Inter-Faculty Football Cup',
      category: EventCategory.sports,
      dateTime: DateTime(2026, 11, 28, 13, 0),
      venue: 'Campus Stadium',
      description:
          'A one-day seven-a-side football tournament between faculty teams. '
          'Register as a player and you will be assigned to your faculty '
          'team. Sports shoes are required.',
      imagePath: 'assets/images/sports_football.png',
      totalCapacity: 64,
      availablePlaces: 18,
    ),
    CampusEvent(
      id: 'E06',
      title: 'Campus 5K Fun Run',
      category: EventCategory.sports,
      dateTime: DateTime(2026, 12, 5, 9, 0),
      venue: 'Sports Complex Running Track',
      description:
          'A friendly 5-kilometre run around the campus for all fitness '
          'levels. Water stations are placed along the route and every '
          'finisher receives a certificate.',
      imagePath: 'assets/images/sports_running.png',
      totalCapacity: 200,
      availablePlaces: 87,
    ),
    CampusEvent(
      id: 'E07',
      title: 'Mobile UI Design Meetup',
      category: EventCategory.technology,
      dateTime: DateTime(2026, 12, 9, 17, 0),
      venue: 'Library Seminar Room 3',
      description:
          'Students share tips on designing clear and accessible mobile '
          'interfaces. The meetup includes a short live redesign of a '
          'sample screen and an open discussion.',
      imagePath: 'assets/images/tech_hackathon.png',
      totalCapacity: 30,
      availablePlaces: 9,
    ),
    CampusEvent(
      id: 'E08',
      title: 'Campus Choir Auditions',
      category: EventCategory.arts,
      dateTime: DateTime(2026, 12, 12, 15, 0),
      venue: 'Music Building, Room M-101',
      description:
          'The campus choir is looking for new voices for the spring '
          'concert. Each audition takes about ten minutes; prepare a short '
          'song of your choice.',
      imagePath: 'assets/images/arts_music.png',
      totalCapacity: 25,
      availablePlaces: 6,
    ),
  ];
}

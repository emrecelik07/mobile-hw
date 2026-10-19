import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../logic/event_manager.dart';
import '../models/campus_event.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import '../widgets/event_search_field.dart';
import '../widgets/joined_count_badge.dart';
import 'event_details_screen.dart';

/// The three main views reachable from the bottom navigation bar.
enum HomeView { explore, favorites, myEvents }

/// Root screen with the Explore, Favorites and My Events views.
///
/// It owns the session state ([EventManager]) and the shared search/category
/// settings, which apply to all three views.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventManager _manager = EventManager(createSampleEvents());
  final TextEditingController _searchController = TextEditingController();
  EventCategory? _selectedCategory;
  HomeView _currentView = HomeView.explore;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CampusEvent> get _eventsForCurrentView => switch (_currentView) {
    HomeView.explore => _manager.events,
    HomeView.favorites => _manager.favoriteEvents,
    HomeView.myEvents => _manager.joinedEvents,
  };

  String get _title => switch (_currentView) {
    HomeView.explore => 'Campus Events',
    HomeView.favorites => 'Favorites',
    HomeView.myEvents => 'My Events',
  };

  void _clearSearch() {
    setState(_searchController.clear);
  }

  void _showAllCategories() {
    setState(() => _selectedCategory = null);
  }

  void _toggleFavorite(CampusEvent event) {
    setState(() => _manager.toggleFavorite(event));
  }

  Future<void> _openDetails(CampusEvent event) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailsScreen(
          event: event,
          manager: _manager,
          onChanged: () => setState(() {}),
        ),
      ),
    );
    // Rebuild once more so the lists reflect every change made on details.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visibleEvents = EventManager.filter(
      _eventsForCurrentView,
      query: _searchController.text,
      category: _selectedCategory,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [JoinedCountBadge(count: _manager.joinedCount)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: EventSearchField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              onClear: _clearSearch,
            ),
          ),
          CategoryFilterBar(
            selected: _selectedCategory,
            onSelected: (category) =>
                setState(() => _selectedCategory = category),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text(
              '${visibleEvents.length} matching '
              '${visibleEvents.length == 1 ? 'event' : 'events'}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(
            child: visibleEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    key: PageStorageKey<HomeView>(_currentView),
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: visibleEvents.length,
                    itemBuilder: (context, index) {
                      final event = visibleEvents[index];
                      return EventCard(
                        event: event,
                        isFavorite: _manager.isFavorite(event),
                        isJoined: _manager.isJoined(event),
                        onFavoritePressed: () => _toggleFavorite(event),
                        onOpenDetails: () => _openDetails(event),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentView.index,
        onDestinationSelected: (index) =>
            setState(() => _currentView = HomeView.values[index]),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _manager.joinedCount > 0,
              label: Text('${_manager.joinedCount}'),
              child: const Icon(Icons.event_note_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _manager.joinedCount > 0,
              label: Text('${_manager.joinedCount}'),
              child: const Icon(Icons.event_note),
            ),
            label: 'My Events',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // The current view has no events at all (before any filtering).
    if (_eventsForCurrentView.isEmpty) {
      if (_currentView == HomeView.favorites) {
        return const EmptyState(
          icon: Icons.favorite_border,
          title: 'No favorite events yet',
          message: 'Tap the heart on any event to save it here.',
        );
      }
      if (_currentView == HomeView.myEvents) {
        return const EmptyState(
          icon: Icons.event_busy,
          title: 'You have not joined any events yet',
          message: 'Open an event and tap "Join event" to participate.',
        );
      }
    }

    // Events exist, but the search and/or category filter hides all of them.
    return EmptyState(
      icon: Icons.search_off,
      title: 'No events match your search',
      message: 'Try a different title or category.',
      actions: [
        if (_searchController.text.isNotEmpty)
          OutlinedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear),
            label: const Text('Clear search'),
          ),
        if (_selectedCategory != null)
          OutlinedButton.icon(
            onPressed: _showAllCategories,
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Show all categories'),
          ),
      ],
    );
  }
}

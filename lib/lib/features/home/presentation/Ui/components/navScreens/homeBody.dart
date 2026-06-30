import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/lib/core/service/hive/hive_service.dart';
import 'package:eventhub/lib/core/service/hive/saved_event_model.dart';
import 'package:eventhub/lib/core/service/hive/session_service.dart';
import 'package:eventhub/lib/core/service/hive/user_model.dart';
import 'package:eventhub/lib/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/lib/features/home/data/event_data_source.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/lib/features/home/presentation/model/category.dart';
import 'package:eventhub/lib/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const double _headerHeight = 200;
  int _selectedCategoryIndex = 0;

  late Future<List<EventEntity>> _eventsFuture;
  String? _userEmail;
  UserModel? _user;
  Set<String> _savedIds = {};

  static const List<Category> _categories = [
    Category('Sports',  Icons.sports_basketball,       Color(0xFFED5B4F)),
    Category('Music',   Icons.music_note,               Color(0xFFF0954A)),
    Category('Food',    Icons.restaurant,               Color(0xFF3CB99A)),
    Category('Art',     Icons.palette,                  Color(0xFF5669FF)),
    Category('Theatre', Icons.theater_comedy,           Color(0xFF9C27B0)),
    Category('Comedy',  Icons.sentiment_very_satisfied, Color(0xFFE91E63)),
  ];

  @override
  void initState() {
    super.initState();
    _eventsFuture = EventDataSource.getEvents();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final email = await SessionService.getLoggedEmail();
    if (!mounted) return;
    setState(() {
      _userEmail = email;
      _user      = email != null ? HiveService.findUser(email) : null;
      _savedIds  = HiveService.getSavedEvents(email ?? '')
          .map((e) => e.id)
          .toSet();
    });
  }

  void _refresh() => setState(() {
        _eventsFuture = EventDataSource.getEvents();
      });

  Future<void> _toggleSave(EventEntity event) async {
    if (_userEmail == null) return;
    final model = SavedEventModel(
      id:            event.id,
      name:          event.name,
      imageUrl:      event.imageUrl,
      location:      event.location,
      formattedDate: event.formattedDate,
      localTime:     event.localTime,
      type:          event.type,
      userEmail:     _userEmail!,
    );
    final nowSaved = await HiveService.toggleSave(model);
    if (!mounted) return;
    setState(() {
      if (nowSaved) _savedIds.add(event.id);
      else           _savedIds.remove(event.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventEntity>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        final events    = snapshot.data ?? [];
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError  = snapshot.hasError;

        return Stack(children: [
          Column(children: [
            _buildHeader(context),
            Expanded(
              child: hasError
                  ? _buildError(context)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 56),
                          _buildUpcomingSection(context, events, isLoading),
                          const SizedBox(height: 24),
                          _buildInviteBanner(),
                          const SizedBox(height: 24),
                          _buildNearbySection(context, events, isLoading),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
          ]),
          Positioned(
            top: _headerHeight - 24,
            left: 0, right: 0,
            child: _buildCategories(context),
          ),
        ]);
      },
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: _headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColours.purpleColour,
        borderRadius: const BorderRadius.only(
          bottomLeft:  Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuLine(20), const SizedBox(height: 4),
                  _menuLine(14), const SizedBox(height: 4),
                  _menuLine(20),
                ],
              ),
              const Spacer(),
              // Location
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Current Location',
                    style: AppTextStyles.fontStyle12
                        .copyWith(color: Colors.white70)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.location_on,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('New York, USA',
                      style: AppTextStyles.fontStyle14
                          .copyWith(color: Colors.white,
                              fontWeight: FontWeight.w700)),
                ]),
              ]),
              const Spacer(),
              // User avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white30,
                child: Text(
                  _user?.name.isNotEmpty == true
                      ? _user!.name[0].toUpperCase()
                      : 'G',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            // Search bar
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Icons.search, color: AppColours.greyColour, size: 20),
                  const SizedBox(width: 8),
                  Text('Search events...',
                      style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.greyColour)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _menuLine(double w) => Container(
        width: w, height: 2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(1)));

  // ── Categories ──────────────────────────────────────────────────────────
  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat  = _categories[i];
          final sel  = _selectedCategoryIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = i);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      SearchScreen(initialCategory: cat.label)));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: sel ? cat.color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08),
                      blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Row(children: [
                Icon(cat.icon,
                    color: sel ? Colors.white : cat.color, size: 18),
                const SizedBox(width: 6),
                Text(cat.label,
                    style: AppTextStyles.fontStyle14.copyWith(
                        color: sel ? Colors.white : AppColours.blackColour,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          );
        },
      ),
    );
  }

  // ── Upcoming events ─────────────────────────────────────────────────────
  Widget _buildUpcomingSection(
      BuildContext context, List<EventEntity> events, bool loading) {
    final upcoming = events
        .where((e) => e.startDate.isAfter(DateTime.now()))
        .take(10)
        .toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('Upcoming Events',
              style: AppTextStyles.fontStyle18.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColours.blackColour)),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen())),
            child: Text('See All',
                style: AppTextStyles.fontStyle14
                    .copyWith(color: AppColours.primaryColour)),
          ),
        ]),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 270,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: upcoming.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          EventDetailsScreen(eventData: upcoming[i]))),
                  child: _EventCard(
                    event: upcoming[i],
                    isSaved: _savedIds.contains(upcoming[i].id),
                    onSaveToggle: () => _toggleSave(upcoming[i]),
                  ),
                ),
              ),
      ),
    ]);
  }

  // ── Invite banner ───────────────────────────────────────────────────────
  Widget _buildInviteBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColours.primaryColour, AppColours.trinaryColour],
            begin: Alignment.centerLeft, end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Invite your friends',
                  style: AppTextStyles.fontStyle18.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Get \$20 for ticket',
                  style: AppTextStyles.fontStyle14
                      .copyWith(color: Colors.white70)),
            ]),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColours.primaryColour,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('INVITE',
                style: AppTextStyles.fontStyle14.copyWith(
                    color: AppColours.primaryColour,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }

  // ── Nearby events ───────────────────────────────────────────────────────
  Widget _buildNearbySection(
      BuildContext context, List<EventEntity> events, bool loading) {
    final nearby = events.take(6).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('Nearby You',
            style: AppTextStyles.fontStyle18.copyWith(
                fontWeight: FontWeight.w800, color: AppColours.blackColour)),
      ),
      const SizedBox(height: 12),
      if (loading)
        const Center(child: CircularProgressIndicator())
      else
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: nearby.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => _NearbyTile(
            event: nearby[i],
            isSaved: _savedIds.contains(nearby[i].id),
            onSaveToggle: () => _toggleSave(nearby[i]),
            onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
                builder: (_) =>
                    EventDetailsScreen(eventData: nearby[i]))),
          ),
        ),
    ]);
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.wifi_off, size: 64, color: AppColours.greyColour),
        const SizedBox(height: 16),
        Text('Could not load events',
            style: AppTextStyles.fontStyle16
                .copyWith(color: AppColours.greyColour)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _refresh,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColours.primaryColour),
          child: Text('Retry',
              style: AppTextStyles.fontStyle14
                  .copyWith(color: Colors.white)),
        ),
      ]),
    );
  }
}

// ── Horizontal event card with save button ─────────────────────────────
class _EventCard extends StatelessWidget {
  final EventEntity event;
  final bool        isSaved;
  final VoidCallback onSaveToggle;
  const _EventCard({required this.event, required this.isSaved,
      required this.onSaveToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255, width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12),
              blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(event.imageUrl,
                  height: 131, width: 218, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 131, width: 218,
                      color: AppColours.iconBgColour,
                      child: Icon(Icons.event,
                          color: AppColours.primaryColour, size: 40))),
            ),
            // Date badge
            Positioned(
              top: 10, left: 10,
              child: Container(
                height: 46, width: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.white.withOpacity(0.85)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('${event.startDate.day}',
                      style: AppTextStyles.fontStyle14.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColours.pinkColour)),
                  Text(event.formattedDate.split(' ').last,
                      style: AppTextStyles.fontStyle12
                          .copyWith(color: AppColours.pinkColour)),
                ]),
              ),
            ),
            // ── Save IconButton ─────────────────────────────────────────
            Positioned(
              top: 4, right: 4,
              child: IconButton(
                onPressed: onSaveToggle,
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved
                      ? AppColours.primaryColour
                      : AppColours.pinkColour,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(event.name,
              style: AppTextStyles.fontStyle16.copyWith(
                  fontWeight: FontWeight.w700, color: AppColours.blackColour),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.location_on_outlined,
                size: 14, color: AppColours.greyColour),
            const SizedBox(width: 4),
            Expanded(
              child: Text(event.location,
                  style: AppTextStyles.fontStyle12
                      .copyWith(color: AppColours.greyColour),
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ── Nearby tile with save button ───────────────────────────────────────
class _NearbyTile extends StatelessWidget {
  final EventEntity  event;
  final bool         isSaved;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;
  const _NearbyTile({required this.event, required this.isSaved,
      required this.onSaveToggle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05),
                blurRadius: 10, offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(event.imageUrl,
                width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 70, height: 70, color: AppColours.iconBgColour,
                    child: Icon(Icons.event,
                        color: AppColours.primaryColour, size: 28))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(event.name,
                  style: AppTextStyles.fontStyle16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColours.blackColour),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(event.formattedDate,
                  style: AppTextStyles.fontStyle12
                      .copyWith(color: AppColours.primaryColour)),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.location_on_outlined,
                    size: 12, color: AppColours.greyColour),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(event.location,
                      style: AppTextStyles.fontStyle12
                          .copyWith(color: AppColours.greyColour),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ]),
          ),
          // ── Save IconButton ─────────────────────────────────────────
          IconButton(
            onPressed: onSaveToggle,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved
                  ? AppColours.primaryColour
                  : AppColours.greyColour,
            ),
          ),
        ]),
      ),
    );
  }
}

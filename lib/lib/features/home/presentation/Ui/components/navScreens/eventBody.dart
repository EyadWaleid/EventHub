import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/lib/core/service/hive/hive_service.dart';
import 'package:eventhub/lib/core/service/hive/saved_event_model.dart';
import 'package:eventhub/lib/core/service/hive/session_service.dart';
import 'package:eventhub/lib/features/home/data/event_data_source.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/lib/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';

class EventsScreenBody extends StatefulWidget {
  const EventsScreenBody({super.key});
  @override
  State<EventsScreenBody> createState() => _EventsScreenBodyState();
}

class _EventsScreenBodyState extends State<EventsScreenBody> {
  bool _isUpcoming = true;
  late Future<List<EventEntity>> _future;
  String? _userEmail;

  // Tracks which event IDs are saved – rebuilt after every toggle
  Set<String> _savedIds = {};

  @override
  void initState() {
    super.initState();
    _future = EventDataSource.getEvents();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final email = await SessionService.getLoggedEmail();
    if (!mounted) return;
    setState(() {
      _userEmail = email;
      _savedIds  = HiveService.getSavedEvents(email ?? '')
          .map((e) => e.id)
          .toSet();
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(),
          const SizedBox(height: 16),
          _buildToggle(),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<EventEntity>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: AppColours.primaryColour));
                }
                if (snapshot.hasError) return _buildError();

                final all = snapshot.data ?? [];
                final now = DateTime.now();
                final upcoming = all
                    .where((e) =>
                        e.startDate.isAfter(now) &&
                        e.startDate.isBefore(now.add(const Duration(days: 7))))
                    .toList()
                  ..sort((a, b) => a.startDate.compareTo(b.startDate));
                final latest = all
                    .where((e) =>
                        e.startDate.isBefore(now) &&
                        e.startDate
                            .isAfter(now.subtract(const Duration(days: 7))))
                    .toList()
                  ..sort((a, b) => b.startDate.compareTo(a.startDate));

                final list = _isUpcoming ? upcoming : latest;
                if (list.isEmpty) {
                  return _buildEmptyState(
                    title: _isUpcoming
                        ? 'No Upcoming Events'
                        : 'No Recent Events',
                    subtitle: _isUpcoming
                        ? 'No events scheduled for the next 7 days'
                        : 'No events happened in the last 7 days',
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _EventTile(
                    event: list[i],
                    isSaved: _savedIds.contains(list[i].id),
                    onSaveToggle: () => _toggleSave(list[i]),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            // import detailsScreen if needed
                            // EventDetailsScreen(eventData: list[i])
                            // Using named route to keep it clean:
                            _NoOpPage())),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(children: [
        Text('Events',
            style: AppTextStyles.fontStyle22
                .copyWith(fontWeight: FontWeight.bold,
                    color: AppColours.blackColour)),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.search, color: AppColours.blackColour),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        ),
      ]),
    );
  }

  Widget _buildToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColours.iconBgColour,
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        _toggleBtn('Upcoming', _isUpcoming,
            () => setState(() => _isUpcoming = true)),
        _toggleBtn('Latest',   !_isUpcoming,
            () => setState(() => _isUpcoming = false)),
      ]),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColours.primaryColour : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: AppTextStyles.fontStyle14.copyWith(
                  color: active ? Colors.white : AppColours.greyColour,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.wifi_off, size: 64, color: AppColours.greyColour),
        const SizedBox(height: 16),
        Text('Could not load events',
            style: AppTextStyles.fontStyle16
                .copyWith(color: AppColours.greyColour)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => setState(() => _future = EventDataSource.getEvents()),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColours.primaryColour),
          child: Text('Retry',
              style: AppTextStyles.fontStyle14.copyWith(color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _buildEmptyState({required String title, required String subtitle}) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.event_busy, size: 72, color: AppColours.greyColour),
        const SizedBox(height: 16),
        Text(title,
            style: AppTextStyles.fontStyle18
                .copyWith(color: AppColours.blackColour,
                    fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: AppTextStyles.fontStyle14, textAlign: TextAlign.center),
      ]),
    );
  }
}

// placeholder so the file compiles standalone
class _NoOpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Scaffold();
}

// ── Event tile with save IconButton ────────────────────────────────────
class _EventTile extends StatelessWidget {
  final EventEntity event;
  final bool        isSaved;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;

  const _EventTile({
    required this.event,
    required this.isSaved,
    required this.onSaveToggle,
    required this.onTap,
  });

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
            BoxShadow(color: Colors.black.withOpacity(0.06),
                blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          // Date badge
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
                color: AppColours.iconBgColour,
                borderRadius: BorderRadius.circular(12)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${event.startDate.day}',
                  style: AppTextStyles.fontStyle18.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColours.primaryColour)),
              Text(event.formattedDate.split(' ').last,
                  style: AppTextStyles.fontStyle12
                      .copyWith(color: AppColours.primaryColour)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.name,
                  style: AppTextStyles.fontStyle16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColours.blackColour),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.access_time_outlined,
                    size: 12, color: AppColours.greyColour),
                const SizedBox(width: 4),
                Text(
                    event.localTime.length >= 5
                        ? event.localTime.substring(0, 5)
                        : event.localTime,
                    style: AppTextStyles.fontStyle12
                        .copyWith(color: AppColours.greyColour)),
              ]),
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
          const SizedBox(width: 4),
          // ── Save / unsave IconButton ────────────────────────────────
          IconButton(
            onPressed: onSaveToggle,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppColours.primaryColour : AppColours.greyColour,
            ),
            tooltip: isSaved ? 'Remove from saved' : 'Save event',
          ),
        ]),
      ),
    );
  }
}

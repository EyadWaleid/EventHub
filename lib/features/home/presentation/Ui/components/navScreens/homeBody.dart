import 'package:eventhub/core/Di/injection.dart';
import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/home/presentation/cubit/home_cubit.dart';
import 'package:eventhub/features/home/presentation/cubit/home_state.dart';
import 'package:eventhub/features/home/presentation/model/category.dart';
import 'package:eventhub/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  static const double _headerHeight = 200;
  int _selectedCategory = 0;

  static const List<Category> _categories = [
    Category('Sports',  Icons.sports_basketball,       Color(0xFFED5B4F)),
    Category('Music',   Icons.music_note,               Color(0xFFF0954A)),
    Category('Food',    Icons.restaurant,               Color(0xFF3CB99A)),
    Category('Art',     Icons.palette,                  Color(0xFF5669FF)),
    Category('Theatre', Icons.theater_comedy,           Color(0xFF9C27B0)),
    Category('Comedy',  Icons.sentiment_very_satisfied, Color(0xFFE91E63)),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final events    = state is HomeLoaded ? state.events : <EventEntity>[];
        final isLoading = state is HomeLoading;
        final hasError  = state is HomeError;

        return Stack(children: [
          Column(children: [
            _buildHeader(context),
            Expanded(
              child: hasError
                  ? _buildError(context, (state as HomeError).message)
                  : SingleChildScrollView(
                      child: Column(children: [
                        const SizedBox(height: 56),
                        _buildUpcoming(context, events, isLoading),
                        const SizedBox(height: 24),
                        _buildInviteBanner(),
                        const SizedBox(height: 24),
                        _buildNearby(context, events, isLoading),
                        const SizedBox(height: 100),
                      ]),
                    ),
            ),
          ]),
          Positioned(
            top: _headerHeight - 24, left: 0, right: 0,
            child: _buildCategories(context),
          ),
        ]);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: _headerHeight, width: double.infinity,
      decoration: BoxDecoration(
        color: AppColours.purpleColour,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Column(mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _line(20), const SizedBox(height: 4),
                _line(14), const SizedBox(height: 4),
                _line(20),
              ]),
              const Spacer(),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Current Location',
                    style: AppTextStyles.fontStyle12.copyWith(color: Colors.white70)),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('New York, USA',
                      style: AppTextStyles.fontStyle14.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ]),
              ]),
              const Spacer(),
              const CircleAvatar(
                radius: 20, backgroundColor: Colors.white30,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ]),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(12)),
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

  Widget _line(double w) => Container(
      width: w, height: 2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(1)));

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final sel = _selectedCategory == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = i);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchScreen(initialCategory: cat.label)));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: sel ? cat.color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                Icon(cat.icon, color: sel ? Colors.white : cat.color, size: 18),
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

  Widget _buildUpcoming(
      BuildContext context, List<EventEntity> events, bool loading) {
    final list = events
        .where((e) => e.startDate.isAfter(DateTime.now()))
        .take(10).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('Upcoming Events',
              style: AppTextStyles.fontStyle18.copyWith(
                  fontWeight: FontWeight.w800, color: AppColours.blackColour)),
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
                itemCount: list.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(eventData: list[i]))),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (ctx, state) => _EventCard(
                      event: list[i],
                      isSaved: ctx.read<HomeCubit>().savedIds.contains(list[i].id),
                      onSaveToggle: () => ctx.read<HomeCubit>().toggleSave(list[i]),
                    ),
                  ),
                ),
              ),
      ),
    ]);
  }

  Widget _buildNearby(
      BuildContext context, List<EventEntity> events, bool loading) {
    final list = events.take(5).toList();
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
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => BlocBuilder<HomeCubit, HomeState>(
            builder: (ctx, state) => _NearbyTile(
              event: list[i],
              isSaved: ctx.read<HomeCubit>().savedIds.contains(list[i].id),
              onSaveToggle: () => ctx.read<HomeCubit>().toggleSave(list[i]),
              onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
                  builder: (_) => EventDetailsScreen(eventData: list[i]))),
            ),
          ),
        ),
    ]);
  }

  Widget _buildInviteBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColours.primaryColour, AppColours.trinaryColour],
              begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Invite your friends',
                style: AppTextStyles.fontStyle18.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Get \$20 for ticket',
                style: AppTextStyles.fontStyle14.copyWith(color: Colors.white70)),
          ])),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColours.primaryColour,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text('INVITE',
                style: AppTextStyles.fontStyle14.copyWith(
                    color: AppColours.primaryColour, fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.wifi_off, size: 64, color: AppColours.greyColour),
      const SizedBox(height: 16),
      Text(message, style: AppTextStyles.fontStyle16
          .copyWith(color: AppColours.greyColour), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => context.read<HomeCubit>().loadEvents(),
        style: ElevatedButton.styleFrom(backgroundColor: AppColours.primaryColour),
        child: Text('Retry',
            style: AppTextStyles.fontStyle14.copyWith(color: Colors.white)),
      ),
    ]));
  }
}

class _EventCard extends StatelessWidget {
  final EventEntity event;
  final bool isSaved;
  final VoidCallback onSaveToggle;
  const _EventCard({required this.event, required this.isSaved, required this.onSaveToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255, width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12),
              blurRadius: 8, offset: const Offset(0, 3))]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(event.imageUrl, height: 131, width: 218,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 131, width: 218, color: AppColours.iconBgColour,
                      child: Icon(Icons.event, color: AppColours.primaryColour, size: 40))),
            ),
            Positioned(top: 10, left: 10,
              child: Container(
                height: 46, width: 46,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(17),
                    color: Colors.white.withOpacity(0.85)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${event.startDate.day}', style: AppTextStyles.fontStyle14
                      .copyWith(fontWeight: FontWeight.w700, color: AppColours.pinkColour)),
                  Text(event.formattedDate.split(' ').last,
                      style: AppTextStyles.fontStyle12.copyWith(color: AppColours.pinkColour)),
                ]),
              ),
            ),
            Positioned(top: 4, right: 4,
              child: IconButton(
                onPressed: onSaveToggle,
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? AppColours.primaryColour : AppColours.pinkColour, size: 22),
                style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                    padding: const EdgeInsets.all(10)),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(event.name, style: AppTextStyles.fontStyle16.copyWith(
              fontWeight: FontWeight.w700, color: AppColours.blackColour),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.location_on_outlined, size: 14, color: AppColours.greyColour),
            const SizedBox(width: 4),
            Expanded(child: Text(event.location,
                style: AppTextStyles.fontStyle12.copyWith(color: AppColours.greyColour),
                overflow: TextOverflow.ellipsis)),
          ]),
        ]),
      ),
    );
  }
}

class _NearbyTile extends StatelessWidget {
  final EventEntity event;
  final bool isSaved;
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
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
                blurRadius: 10, offset: const Offset(0, 2))]),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(event.imageUrl, width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 70, height: 70, color: AppColours.iconBgColour,
                    child: Icon(Icons.event, color: AppColours.primaryColour, size: 28))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.name, style: AppTextStyles.fontStyle16.copyWith(
                fontWeight: FontWeight.w700, color: AppColours.blackColour),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(event.formattedDate,
                style: AppTextStyles.fontStyle12.copyWith(color: AppColours.primaryColour)),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 12, color: AppColours.greyColour),
              const SizedBox(width: 4),
              Expanded(child: Text(event.location,
                  style: AppTextStyles.fontStyle12.copyWith(color: AppColours.greyColour),
                  overflow: TextOverflow.ellipsis)),
            ]),
          ])),
          IconButton(
            onPressed: onSaveToggle,
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? AppColours.primaryColour : AppColours.greyColour),
          ),
        ]),
      ),
    );
  }
}

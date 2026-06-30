import 'package:eventhub/core/Di/injection.dart';
import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/home/presentation/cubit/events_cubit.dart';
import 'package:eventhub/features/home/presentation/cubit/events_state.dart';
import 'package:eventhub/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreenBody extends StatelessWidget {
  const EventsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EventsView();
  }
}

class _EventsView extends StatefulWidget {
  const _EventsView();
  @override
  State<_EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<_EventsView> {
  bool _isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            return Column(children: [
              _buildAppBar(context),
              const SizedBox(height: 16),
              _buildToggle(context),
              const SizedBox(height: 16),
              Expanded(child: _buildContent(context, state)),
              if (state is! EventsLoading) _buildExploreBtn(context),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(children: [
        Text('Events', style: AppTextStyles.fontStyle22.copyWith(
            fontWeight: FontWeight.bold, color: AppColours.blackColour)),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.search, color: AppColours.blackColour),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        ),
      ]),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColours.iconBgColour, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        _toggleBtn('Upcoming',  _isUpcoming,  () => setState(() => _isUpcoming = true)),
        _toggleBtn('Latest',    !_isUpcoming, () => setState(() => _isUpcoming = false)),
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
          child: Text(label, style: AppTextStyles.fontStyle14.copyWith(
              color: active ? Colors.white : AppColours.greyColour,
              fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, EventsState state) {
    if (state is EventsLoading || state is EventsInitial) {
      return Center(child: CircularProgressIndicator(color: AppColours.primaryColour));
    }
    if (state is EventsError) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.wifi_off, size: 64, color: AppColours.greyColour),
        const SizedBox(height: 16),
        Text(state.message, style: AppTextStyles.fontStyle16
            .copyWith(color: AppColours.greyColour), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.read<EventsCubit>().loadEvents(),
          style: ElevatedButton.styleFrom(backgroundColor: AppColours.primaryColour),
          child: Text('Retry',
              style: AppTextStyles.fontStyle14.copyWith(color: Colors.white)),
        ),
      ]));
    }
    if (state is EventsLoaded) {
      final list = _isUpcoming ? state.upcoming : state.latest;
      if (list.isEmpty) {
        return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.event_busy, size: 72, color: AppColours.greyColour),
          const SizedBox(height: 16),
          Text(_isUpcoming ? 'No Upcoming Events' : 'No Recent Events',
              style: AppTextStyles.fontStyle18.copyWith(
                  fontWeight: FontWeight.w700, color: AppColours.blackColour)),
          const SizedBox(height: 8),
          Text(_isUpcoming
              ? 'No events scheduled for the next 7 days'
              : 'No events happened in the last 7 days',
              style: AppTextStyles.fontStyle14, textAlign: TextAlign.center),
        ]));
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) => _EventTile(
          event: list[i],
          isSaved: ctx.read<EventsCubit>().savedIds.contains(list[i].id),
          onSaveToggle: () => ctx.read<EventsCubit>().toggleSave(list[i]),
          onTap: () => Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => EventDetailsScreen(eventData: list[i]))),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildExploreBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SearchScreen())),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColours.primaryColour,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text('EXPLORE EVENTS', style: AppTextStyles.fontStyle16.copyWith(
            color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final EventEntity event;
  final bool isSaved;
  final VoidCallback onSaveToggle;
  final VoidCallback onTap;
  const _EventTile({required this.event, required this.isSaved,
      required this.onSaveToggle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
                blurRadius: 10, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: AppColours.iconBgColour,
                borderRadius: BorderRadius.circular(12)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${event.startDate.day}', style: AppTextStyles.fontStyle18.copyWith(
                  fontWeight: FontWeight.w800, color: AppColours.primaryColour)),
              Text(event.formattedDate.split(' ').last,
                  style: AppTextStyles.fontStyle12.copyWith(color: AppColours.primaryColour)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.name, style: AppTextStyles.fontStyle16.copyWith(
                fontWeight: FontWeight.w700, color: AppColours.blackColour),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Icon(Icons.access_time_outlined, size: 12, color: AppColours.greyColour),
              const SizedBox(width: 4),
              Text(event.localTime.length >= 5 ? event.localTime.substring(0, 5) : event.localTime,
                  style: AppTextStyles.fontStyle12.copyWith(color: AppColours.greyColour)),
            ]),
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

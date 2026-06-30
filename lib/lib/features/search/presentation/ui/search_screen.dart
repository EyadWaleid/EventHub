import 'dart:async';
import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/lib/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/lib/features/home/data/event_data_source.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  const SearchScreen({super.key, this.initialCategory});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  // null means "user hasn't typed yet" — show idle state
  Future<List<EventEntity>>? _searchFuture;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() => _searchFuture = null);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchFuture = widget.initialCategory != null
            ? EventDataSource.searchByCategory(
                widget.initialCategory!, value.trim())
            : EventDataSource.searchEvents(value.trim());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            _buildSearchBar(),
            if (widget.initialCategory != null) ...[
              const SizedBox(height: 12),
              _buildCategoryChip(),
            ],
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: AppColours.iconBgColour, shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_ios_new,
                size: 16, color: AppColours.blackColour),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          widget.initialCategory ?? 'Search',
          style: AppTextStyles.fontStyle22.copyWith(
              fontWeight: FontWeight.w800, color: AppColours.blackColour),
        ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColours.borderColour),
        ),
        child: Row(children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: AppColours.primaryColour, size: 22),
          const SizedBox(width: 6),
          Container(width: 1, height: 22, color: AppColours.borderColour),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
              style: AppTextStyles.fontStyle16
                  .copyWith(color: AppColours.blackColour),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: AppTextStyles.fontStyle16
                    .copyWith(color: AppColours.greyColour),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Filters pill
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
                color: AppColours.primaryColour,
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.tune, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text('Filters',
                  style: AppTextStyles.fontStyle12
                      .copyWith(color: Colors.white)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColours.primaryColour.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColours.primaryColour.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.label_outline, size: 14, color: AppColours.primaryColour),
          const SizedBox(width: 6),
          Text('Category: ${widget.initialCategory}',
              style: AppTextStyles.fontStyle12.copyWith(
                  color: AppColours.primaryColour,
                  fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  Widget _buildBody() {
    // No query yet — idle
    if (_searchFuture == null) return _buildIdle();

    return FutureBuilder<List<EventEntity>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator(color: AppColours.primaryColour));
        }
        if (snapshot.hasError) {
          return _buildError();
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) return _buildNoResults();
        return _buildResults(context, results);
      },
    );
  }

  Widget _buildIdle() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 72, color: AppColours.borderColour),
          const SizedBox(height: 16),
          Text('Start typing to search events',
              style: AppTextStyles.fontStyle16.copyWith(
                  color: AppColours.greyColour,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            widget.initialCategory != null
                ? 'Searching in ${widget.initialCategory}'
                : 'Find concerts, shows, sports & more',
            style: AppTextStyles.fontStyle14
                .copyWith(color: AppColours.fadedTextColour),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 72, color: AppColours.borderColour),
          const SizedBox(height: 16),
          Text('No events found',
              style: AppTextStyles.fontStyle18.copyWith(
                  color: AppColours.blackColour,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Try a different keyword or category',
              style: AppTextStyles.fontStyle14
                  .copyWith(color: AppColours.greyColour)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: AppColours.greyColour),
          const SizedBox(height: 16),
          Text('Something went wrong',
              style: AppTextStyles.fontStyle16
                  .copyWith(color: AppColours.greyColour)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _onChanged(_controller.text),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.primaryColour),
            child: Text('Retry',
                style: AppTextStyles.fontStyle14
                    .copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, List<EventEntity> results) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _SearchTile(
        event: results[i],
        onTap: () => Navigator.of(ctx).push(
            MaterialPageRoute(builder: (_) => EventDetailsScreen(eventData: results[i],))),
      ),
    );
  }
}

// ─── Search result tile ───────────────────────────────────────────────────────

class _SearchTile extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  const _SearchTile({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16)),
            child: Image.network(
              event.imageUrl, width: 90, height: 90, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90, height: 90, color: AppColours.iconBgColour,
                child: Icon(Icons.event,
                    color: AppColours.primaryColour, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.formattedDate}  ·  '
                    '${event.localTime.length >= 5 ? event.localTime.substring(0, 5) : event.localTime}',
                    style: AppTextStyles.fontStyle12.copyWith(
                        color: AppColours.primaryColour,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(event.name,
                      style: AppTextStyles.fontStyle16.copyWith(
                          color: AppColours.blackColour,
                          fontWeight: FontWeight.w700),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ]),
      ),
    );
  }
}

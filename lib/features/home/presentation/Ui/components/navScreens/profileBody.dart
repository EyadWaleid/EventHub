import 'package:eventhub/features/profile/data/repo/profile_repository_impl.dart';
import 'package:eventhub/features/profile/domain/usecases/profile_usecases.dart';
import 'package:eventhub/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/features/profile/domain/entities/profile_entity.dart';
import 'package:eventhub/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ProfileRepositoryImpl();
    return BlocProvider(
      create: (_) => ProfileCubit(
        getProfileUseCase: GetProfileUseCase(repo),
        unsaveEventUseCase: UnsaveEventUseCase(repo),
        logoutUseCase: LogoutUseCase(repo),
      )..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                    color: AppColours.primaryColour),
              ),
            );
          }

          if (state is ProfileError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: AppColours.greyColour),
                    const SizedBox(height: 16),
                    Text(state.message,
                        style: AppTextStyles.fontStyle16
                            .copyWith(color: AppColours.greyColour)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColours.primaryColour),
                      child: Text('Retry',
                          style: AppTextStyles.fontStyle14
                              .copyWith(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            return _buildScaffold(context, state.profile);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, ProfileEntity profile) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(context, profile),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildAboutTab(profile),
                _buildEventsTab(context, profile),
                _buildReviewsTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, ProfileEntity profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(children: [
        // Avatar
        Stack(alignment: Alignment.bottomRight, children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColours.iconBgColour,
            backgroundImage: profile.avatarUrl != null
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: profile.avatarUrl == null
                ? Icon(Icons.person,
                    size: 52, color: AppColours.primaryColour)
                : null,
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                color: AppColours.primaryColour, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_outlined,
                color: Colors.white, size: 16),
          ),
        ]),
        const SizedBox(height: 12),

        // Name from Hive
        Text(
          profile.name,
          style: AppTextStyles.fontStyle24.copyWith(
              fontWeight: FontWeight.bold, color: AppColours.blackColour),
        ),
        const SizedBox(height: 12),

        // Following / Followers
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _stat('350', 'Following'),
          Container(
              width: 1,
              height: 36,
              color: AppColours.borderColour,
              margin: const EdgeInsets.symmetric(horizontal: 24)),
          _stat('346', 'Followers'),
        ]),
        const SizedBox(height: 16),

        // Edit Profile button
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Edit Profile'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColours.primaryColour,
            side: BorderSide(color: AppColours.primaryColour),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            minimumSize: const Size(200, 48),
          ),
        ),
        const SizedBox(height: 8),

        // Logout — calls cubit, never calls SessionService directly
        TextButton.icon(
          onPressed: () => context.read<ProfileCubit>().logout(),
          icon: const Icon(Icons.logout, size: 18, color: Colors.red),
          label: Text('Log out',
              style:
                  AppTextStyles.fontStyle14.copyWith(color: Colors.red)),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _stat(String value, String label) => Column(children: [
        Text(value,
            style: AppTextStyles.fontStyle18.copyWith(
                fontWeight: FontWeight.bold, color: AppColours.blackColour)),
        Text(label, style: AppTextStyles.fontStyle14),
      ]);

  // ── Tab bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return TabBar(
      controller: _tab,
      labelColor: AppColours.primaryColour,
      unselectedLabelColor: AppColours.greyColour,
      indicatorColor: AppColours.primaryColour,
      labelStyle:
          AppTextStyles.fontStyle14.copyWith(fontWeight: FontWeight.w700),
      tabs: const [
        Tab(text: 'ABOUT'),
        Tab(text: 'EVENT'),
        Tab(text: 'REVIEWS'),
      ],
    );
  }

  // ── About tab ─────────────────────────────────────────────────────────────

  Widget _buildAboutTab(ProfileEntity profile) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Email: ${profile.email}',
          style: AppTextStyles.fontStyle15
              .copyWith(color: AppColours.aboutTextColour),
        ),
        const SizedBox(height: 12),
        Text(
          'Enjoy your favorite dishes and a lovely time with your '
          'friends and family and have a great time. '
          'Food from local food trucks will be available for purchase.',
          style: AppTextStyles.fontStyle15.copyWith(
              color: AppColours.aboutTextColour, height: 1.6),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Text('Read More',
              style: AppTextStyles.fontStyle15.copyWith(
                  color: AppColours.primaryColour,
                  fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  // ── Events tab — saved events from Hive ───────────────────────────────────

  Widget _buildEventsTab(BuildContext context, ProfileEntity profile) {
    if (profile.savedEvents.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.bookmark_border, size: 64, color: AppColours.greyColour),
          const SizedBox(height: 16),
          Text('No saved events yet',
              style: AppTextStyles.fontStyle16
                  .copyWith(color: AppColours.greyColour)),
          const SizedBox(height: 8),
          Text('Tap the bookmark icon on any event to save it',
              style: AppTextStyles.fontStyle14,
              textAlign: TextAlign.center),
        ]),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: profile.savedEvents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final event = profile.savedEvents[i];
        return _SavedEventTile(
          event: event,
          onUnsave: () => context.read<ProfileCubit>().unsaveEvent(event),
        );
      },
    );
  }

  // ── Reviews tab ───────────────────────────────────────────────────────────

  Widget _buildReviewsTab() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.star_border_rounded,
            size: 64, color: AppColours.greyColour),
        const SizedBox(height: 16),
        Text('No reviews yet',
            style: AppTextStyles.fontStyle16
                .copyWith(color: AppColours.greyColour)),
      ]),
    );
  }
}


class _SavedEventTile extends StatelessWidget {
  final SavedEventModel event;
  final VoidCallback onUnsave;
  const _SavedEventTile({required this.event, required this.onUnsave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            event.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 70,
              height: 70,
              color: AppColours.iconBgColour,
              child: Icon(Icons.event,
                  color: AppColours.primaryColour, size: 28),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.name,
                style: AppTextStyles.fontStyle16.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColours.blackColour),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
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
        IconButton(
          icon: Icon(Icons.bookmark, color: AppColours.primaryColour),
          onPressed: onUnsave,
          tooltip: 'Remove from saved',
        ),
      ]),
    );
  }
}

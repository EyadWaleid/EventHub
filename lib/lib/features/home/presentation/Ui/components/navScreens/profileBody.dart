
import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/lib/core/service/hive/hive_service.dart';
import 'package:eventhub/lib/core/service/hive/saved_event_model.dart';
import 'package:eventhub/lib/core/service/hive/session_service.dart';
import 'package:eventhub/lib/core/service/hive/user_model.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  UserModel? _user;
  List<SavedEventModel> _saved = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final email = await SessionService.getLoggedEmail();
    if (email == null) return;
    final user = HiveService.findUser(email);
    final saved = HiveService.getSavedEvents(email);
    if (mounted) setState(() { _user = user; _saved = saved; });
  }

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildAboutTab(),
                _buildEventsTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ── Header (matches the design screenshot) ────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(children: [
        // Avatar
        Stack(alignment: Alignment.bottomRight, children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColours.iconBgColour,
            backgroundImage: _user?.avatarUrl != null
                ? NetworkImage(_user!.avatarUrl!)
                : null,
            child: _user?.avatarUrl == null
                ? Icon(Icons.person,
                    size: 52, color: AppColours.primaryColour)
                : null,
          ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
                color: AppColours.primaryColour, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_outlined,
                color: Colors.white, size: 16),
          ),
        ]),
        const SizedBox(height: 12),

        // Name
        Text(
          _user?.name ?? 'Guest',
          style: AppTextStyles.fontStyle24
              .copyWith(fontWeight: FontWeight.bold, color: AppColours.blackColour),
        ),
        const SizedBox(height: 12),

        // Following / Followers row
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _stat('350', 'Following'),
          Container(
              width: 1, height: 36,
              color: AppColours.borderColour,
              margin: const EdgeInsets.symmetric(horizontal: 24)),
          _stat('346', 'Followers'),
        ]),
        const SizedBox(height: 16),

        // Edit profile button
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

        // Logout
        TextButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout, size: 18, color: Colors.red),
          label: Text('Log out',
              style: AppTextStyles.fontStyle14.copyWith(color: Colors.red)),
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

  // ── Tab bar ────────────────────────────────────────────────────────────
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

  // ── About tab ─────────────────────────────────────────────────────────
  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Email: ${_user?.email ?? '—'}',
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
        Text('Read More',
            style: AppTextStyles.fontStyle15.copyWith(
                color: AppColours.primaryColour,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }

  // ── Events tab – shows saved events ───────────────────────────────────
  Widget _buildEventsTab() {
    if (_saved.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.bookmark_border,
              size: 64, color: AppColours.greyColour),
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
      itemCount: _saved.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final e = _saved[i];
        return _SavedEventTile(
          event: e,
          onUnsave: () async {
            await HiveService.toggleSave(e);
            _loadData();
          },
        );
      },
    );
  }

  // ── Reviews tab – placeholder ─────────────────────────────────────────
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

// ── Saved event tile ────────────────────────────────────────────────────
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
          child: Image.network(event.imageUrl,
              width: 70, height: 70, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 70, height: 70,
                  color: AppColours.iconBgColour,
                  child: Icon(Icons.event,
                      color: AppColours.primaryColour, size: 28))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        // Un-save button
        IconButton(
          icon: Icon(Icons.bookmark, color: AppColours.primaryColour),
          onPressed: onUnsave,
          tooltip: 'Remove from saved',
        ),
      ]),
    );
  }
}

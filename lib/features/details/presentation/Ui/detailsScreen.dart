import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/core/service/hive/hive_service.dart';
import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/core/service/hive/session_service.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.eventData});
  final EventEntity eventData;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool    _isSaved   = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _initSaveState();
  }

  Future<void> _initSaveState() async {
    final email = await SessionService.getLoggedEmail();
    if (!mounted) return;
    setState(() {
      _userEmail = email;
      _isSaved   = email != null &&
          HiveService.isSaved(widget.eventData.id, email);
    });
  }

  Future<void> _toggleSave() async {
    if (_userEmail == null) return;
    final model = SavedEventModel(
      id:            widget.eventData.id,
      name:          widget.eventData.name,
      imageUrl:      widget.eventData.imageUrl,
      location:      widget.eventData.location,
      formattedDate: widget.eventData.formattedDate,
      localTime:     widget.eventData.localTime,
      type:          widget.eventData.type,
      userEmail:     _userEmail!,
    );
    final nowSaved = await HiveService.toggleSave(model);
    if (!mounted) return;
    setState(() => _isSaved = nowSaved);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(nowSaved ? 'Event saved!' : 'Removed from saved'),
      backgroundColor:
          nowSaved ? AppColours.primaryColour : AppColours.greyColour,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.backgroundColour,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildHeroSection(context),
            _buildAttendeesCard(),
            const SizedBox(height: 20),
            _buildBody(),
            const SizedBox(height: 100),
          ]),
        ),
        _buildBuyTicketButton(),
      ]),
    );
  }

  // ── Hero ────────────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(children: [
        Positioned.fill(
          child: Image.network(
            widget.eventData.imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.35),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF1A0A2E)),
          ),
        ),
        Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                ),
                Text('Event Details',
                    style: AppTextStyles.fontStyle18.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700)),

                // ── Save IconButton ───────────────────────────────────
                IconButton(
                  onPressed: _toggleSave,
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Attendees card ──────────────────────────────────────────────────────
  Widget _buildAttendeesCard() {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: AppColours.cardShadowColour,
                  blurRadius: 20, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(children: [
            // Overlapping avatars
            SizedBox(
              width: 80,
              height: 36,
              child: Stack(children: [
                for (int i = 0; i < 3; i++)
                  Positioned(
                    left: i * 20.0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=${i + 1}'),
                    ),
                  ),
              ]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text('+20 Going',
                  style: AppTextStyles.fontStyle14.copyWith(
                      color: AppColours.blackColour,
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColours.primaryColour,
                  borderRadius: BorderRadius.circular(20)),
              child: Text('Invite',
                  style: AppTextStyles.fontStyle14
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Body ────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final e = widget.eventData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(e.name,
            style: AppTextStyles.fontStyle24.copyWith(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: AppColours.blackColour, height: 1.2)),
        const SizedBox(height: 24),
        _buildInfoRow(icon: Icons.calendar_month_rounded,
            title: e.formattedDate,
            subtitle: e.localTime.length >= 5
                ? e.localTime.substring(0, 5)
                : e.localTime),
        const SizedBox(height: 16),
        _buildInfoRow(icon: Icons.location_on_rounded,
            title: e.venueName ?? 'Venue TBD',
            subtitle: e.location),
        const SizedBox(height: 16),
        _buildOrganizerRow(),
        const SizedBox(height: 24),
        Text('About Event',
            style: AppTextStyles.fontStyle18.copyWith(
                fontWeight: FontWeight.w800, color: AppColours.blackColour)),
        const SizedBox(height: 10),
        if (e.info != null)
          Text(e.info!,
              style: AppTextStyles.fontStyle15.copyWith(
                  color: AppColours.aboutTextColour, height: 1.6))
        else
          RichText(
            text: TextSpan(
              style: AppTextStyles.fontStyle15.copyWith(
                  color: AppColours.aboutTextColour, height: 1.6),
              children: const [
                TextSpan(
                    text:
                        'Enjoy your favorite dishes and a lovely time with your '
                        'friends and family. '),
                TextSpan(
                    text: 'Food from local food trucks will be available for purchase.',
                    style: TextStyle(color: Color(0xFFB0B0C3))),
                TextSpan(
                    text: ' Read More',
                    style: TextStyle(
                        color: Color(0xFF5669FF),
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
      ]),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
            color: AppColours.iconBgColour,
            borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: AppColours.primaryColour, size: 22),
      ),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: AppTextStyles.fontStyle16.copyWith(
                fontWeight: FontWeight.w700, color: AppColours.blackColour)),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.fontStyle14),
      ]),
    ]);
  }

  Widget _buildOrganizerRow() {
    return Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network('https://i.pravatar.cc/150?img=7',
            width: 48, height: 48, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                width: 48, height: 48, color: AppColours.pinkColour,
                child: const Icon(Icons.person, color: Colors.white))),
      ),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.eventData.attractionName ?? 'Organizer',
            style: AppTextStyles.fontStyle16.copyWith(
                fontWeight: FontWeight.w700, color: AppColours.blackColour)),
        const SizedBox(height: 2),
        Text('Organizer', style: AppTextStyles.fontStyle14),
      ]),
      const Spacer(),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColours.primaryColour),
          foregroundColor: AppColours.primaryColour,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
        child: Text('Follow',
            style: AppTextStyles.fontStyle14.copyWith(
                color: AppColours.primaryColour,
                fontWeight: FontWeight.w600)),
      ),
    ]);
  }

  Widget _buildBuyTicketButton() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06),
                blurRadius: 16, offset: const Offset(0, -4)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColours.primaryColour,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('BUY TICKET',
                style: AppTextStyles.fontStyle16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2)),
            const SizedBox(width: 12),
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 18),
            ),
          ]),
        ),
      ),
    );
  }
}

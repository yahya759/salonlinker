import 'package:flutter/material.dart';

void main() {
  runApp(const BarbershopApp());
}

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nocturnal Atelier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
      ),
      home: const BarbershopDashboard(),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

enum BookingStatus { confirmed, pending }

class Booking {
  final String clientName;
  final String service;
  final String stylist;
  final String schedule;
  final BookingStatus status;
  final String? avatarInitials;

  const Booking({
    required this.clientName,
    required this.service,
    required this.stylist,
    required this.schedule,
    required this.status,
    this.avatarInitials,
  });
}

class LiveActivity {
  final String text;
  const LiveActivity(this.text);
}

// ─────────────────────────────────────────────
// CONSTANTS / THEME COLORS
// ─────────────────────────────────────────────

const Color kBg = Color(0xFF111111);
const Color kSurface = Color(0xFF1C1C1C);
const Color kSurface2 = Color(0xFF222222);
const Color kBorder = Color(0xFF2A2A2A);
const Color kSidebarActive = Color(0xFF2A2A2A);
const Color kAccentGreen = Color(0xFFB5F23D);
const Color kTextPrimary = Color(0xFFFFFFFF);
const Color kTextSecondary = Color(0xFF888888);
const Color kTextMuted = Color(0xFF555555);
const Color kPending = Color(0xFF3A3A3A);
const Color kConfirmedText = Color(0xFF0D0D0D);

// ─────────────────────────────────────────────
// MAIN DASHBOARD
// ─────────────────────────────────────────────

class BarbershopDashboard extends StatefulWidget {
  const BarbershopDashboard({super.key});

  @override
  State<BarbershopDashboard> createState() => _BarbershopDashboardState();
}

class _BarbershopDashboardState extends State<BarbershopDashboard> {
  int _selectedNav = 0;
  bool _showToday = true;

  final List<Booking> _bookings = const [
    Booking(
      clientName: 'Julian\nAlvarez',
      service: 'Classic Fade &\nBeard Trim',
      stylist: 'MARCUS',
      schedule: '5:00 PM',
      status: BookingStatus.confirmed,
    ),
    Booking(
      clientName: 'Damien\nThorne',
      service: 'Buzz Cut &\nLineup',
      stylist: 'ELIAS',
      schedule: '5:45 PM',
      status: BookingStatus.pending,
    ),
    Booking(
      clientName: 'Oliver\nVance',
      service: 'Signature\nScissor Cut',
      stylist: 'MARCUS',
      schedule: '6:30 PM',
      status: BookingStatus.confirmed,
    ),
  ];

  final List<Map<String, String>> _navItems = const [
    {'label': 'DASHBOARD', 'icon': 'dashboard'},
    {'label': 'SCHEDULE', 'icon': 'calendar_today'},
    {'label': 'CLIENTS', 'icon': 'people'},
    {'label': 'BARBERS', 'icon': 'content_cut'},
    {'label': 'ANALYTICS', 'icon': 'bar_chart'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: _selectedNav,
            navItems: _navItems,
            onNavTap: (i) => setState(() => _selectedNav = i),
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(),
                Expanded(
                  child: _MainContent(
                    bookings: _bookings,
                    showToday: _showToday,
                    onToggle: (v) => setState(() => _showToday = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final List<Map<String, String>> navItems;
  final ValueChanged<int> onNavTap;

  const _Sidebar({
    required this.selectedIndex,
    required this.navItems,
    required this.onNavTap,
  });

  static const Map<String, IconData> _icons = {
    'dashboard': Icons.grid_view_rounded,
    'calendar_today': Icons.calendar_today_outlined,
    'people': Icons.people_outline,
    'content_cut': Icons.content_cut_outlined,
    'bar_chart': Icons.show_chart_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      color: kSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.content_cut, color: kTextPrimary, size: 18),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nocturnal',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Atelier',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'MASTER ADMIN',
                      style: TextStyle(
                        color: kTextSecondary,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Nav items
          ...List.generate(navItems.length, (i) {
            final isSelected = i == selectedIndex;
            return _NavItem(
              label: navItems[i]['label']!,
              icon: _icons[navItems[i]['icon']!]!,
              isSelected: isSelected,
              onTap: () => onNavTap(i),
            );
          }),
          const Spacer(),
          // Quick Booking
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16, color: kTextPrimary),
                label: const Text(
                  'Quick Booking',
                  style: TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBorder,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ),
          // Support
          _BottomNavItem(icon: Icons.help_outline, label: 'SUPPORT'),
          _BottomNavItem(icon: Icons.logout, label: 'LOGOUT'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kSidebarActive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? kTextPrimary : kTextSecondary, size: 16),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? kTextPrimary : kTextSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: kTextSecondary, size: 15),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: kTextSecondary,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(bottom: BorderSide(color: kBorder, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          const Text(
            'The Nocturnal Atelier',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: kTextMuted, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Dashboard',
            style: TextStyle(color: kTextSecondary, fontSize: 13),
          ),
          const Icon(Icons.chevron_right, color: kTextMuted, size: 16),
          const Text(
            "Today's Bookings",
            style: TextStyle(color: kTextSecondary, fontSize: 13),
          ),
          const Spacer(),
          _TopBarIcon(icon: Icons.refresh_rounded),
          const SizedBox(width: 8),
          _TopBarIcon(icon: Icons.notifications_none_rounded),
          const SizedBox(width: 8),
          _TopBarIcon(icon: Icons.settings_outlined),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFF3A3A3A),
            child: const Icon(Icons.person, color: kTextSecondary, size: 18),
          ),
        ],
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  final IconData icon;
  const _TopBarIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: kSurface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorder),
      ),
      child: Icon(icon, color: kTextSecondary, size: 17),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN CONTENT
// ─────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  final List<Booking> bookings;
  final bool showToday;
  final ValueChanged<bool> onToggle;

  const _MainContent({
    required this.bookings,
    required this.showToday,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Barbershop Dashboard',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Today's Bookings",
                    style: TextStyle(color: kTextSecondary, fontSize: 13),
                  ),
                ],
              ),
              _TodayTomorrowToggle(showToday: showToday, onToggle: onToggle),
            ],
          ),
          const SizedBox(height: 24),
          // Two columns: bookings list + insights
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bookings list
              Expanded(
                flex: 3,
                child: Column(
                  children: bookings
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _BookingCard(booking: b),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 20),
              // Right panel
              SizedBox(
                width: 230,
                child: Column(
                  children: [
                    _InsightsSummaryCard(),
                    const SizedBox(height: 16),
                    _OnDutyCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TODAY / TOMORROW TOGGLE
// ─────────────────────────────────────────────

class _TodayTomorrowToggle extends StatelessWidget {
  final bool showToday;
  final ValueChanged<bool> onToggle;

  const _TodayTomorrowToggle({required this.showToday, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          _ToggleButton(label: 'Today', isActive: showToday, onTap: () => onToggle(true)),
          _ToggleButton(label: 'Tomorrow', isActive: !showToday, onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? kTextPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? kConfirmedText : kTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOOKING CARD
// ─────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = booking.status == BookingStatus.confirmed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_outline, color: kTextSecondary, size: 26),
          ),
          const SizedBox(width: 16),
          // Name + service
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.clientName,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.service,
                  style: const TextStyle(
                    color: kTextSecondary,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Stylist
          _BookingMeta(
            label: 'STYLIST',
            value: booking.stylist,
            icon: Icons.person,
          ),
          const SizedBox(width: 24),
          // Schedule
          _BookingMeta(
            label: 'SCHEDULE',
            value: booking.schedule,
            icon: null,
          ),
          const Spacer(),
          // Status badge
          _StatusBadge(isConfirmed: isConfirmed),
        ],
      ),
    );
  }
}

class _BookingMeta extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _BookingMeta({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kTextSecondary,
            fontSize: 9,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: kTextSecondary, size: 12),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                color: kTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isConfirmed;
  const _StatusBadge({required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isConfirmed ? kAccentGreen : kPending,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed ? 'CONFIRMED' : 'PENDING',
        style: TextStyle(
          color: isConfirmed ? kConfirmedText : kTextSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INSIGHTS SUMMARY CARD
// ─────────────────────────────────────────────

class _InsightsSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'INSIGHTS SUMMARY',
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          // Revenue
          const Text(
            'Today\'s Revenue',
            style: TextStyle(color: kTextSecondary, fontSize: 11),
          ),
          const SizedBox(height: 4),
          const Text(
            '\$1,420.00',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.trending_up, color: kAccentGreen, size: 14),
              SizedBox(width: 4),
              Text(
                '+12% FROM YESTERDAY',
                style: TextStyle(
                  color: kAccentGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Occupancy
          const Text(
            'Occupancy',
            style: TextStyle(color: kTextSecondary, fontSize: 11),
          ),
          const SizedBox(height: 4),
          const Text(
            '88%',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.88,
              backgroundColor: kBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(kTextPrimary),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 20),
          // Live Activity
          const Text(
            'LIVE ACTIVITY',
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _LiveActivityItem(
            richText: TextSpan(
              children: [
                const TextSpan(
                  text: 'Elias ',
                  style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 11),
                ),
                const TextSpan(
                  text: 'finished a ',
                  style: TextStyle(color: kTextSecondary, fontSize: 11),
                ),
                const TextSpan(
                  text: 'Beard Trim ',
                  style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600, fontSize: 11),
                ),
                const TextSpan(
                  text: 'for client Sarah J.',
                  style: TextStyle(color: kTextSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _LiveActivityItem(
            richText: const TextSpan(
              children: [
                TextSpan(
                  text: 'Booking ',
                  style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 11),
                ),
                TextSpan(
                  text: 'created for 8:00 PM by New Client.',
                  style: TextStyle(color: kTextSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveActivityItem extends StatelessWidget {
  final TextSpan richText;
  const _LiveActivityItem({required this.richText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: kAccentGreen,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(text: richText),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ON DUTY CARD
// ─────────────────────────────────────────────

class _OnDutyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ON DUTY TODAY',
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Stacked avatars
              SizedBox(
                width: 90,
                height: 32,
                child: Stack(
                  children: [
                    _StaffAvatar(offset: 0, color: const Color(0xFF4A6FA5)),
                    _StaffAvatar(offset: 20, color: const Color(0xFF6A5ACD)),
                    _StaffAvatar(offset: 40, color: const Color(0xFF2E8B57)),
                    Positioned(
                      left: 60,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: kSidebarActive,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBg, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '+2',
                            style: TextStyle(
                              color: kTextSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'MANAGE STAFF',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  final double offset;
  final Color color;

  const _StaffAvatar({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: kBg, width: 2),
        ),
        child: const Icon(Icons.person, color: Colors.white54, size: 16),
      ),
    );
  }
}

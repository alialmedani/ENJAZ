// profile_screen_pro.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

class ProfileScreenPro extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  const ProfileScreenPro({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.xprimaryColor,
            elevation: 0,
            expandedHeight: 210,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 12,
              ),
              title: Text(
                'Profile',
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _HeaderWaves(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          _GlowAvatar(size: 64, url: avatarUrl),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.getBoldStyle(
                                    fontSize: AppFontSize.size_16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.getRegularStyle(
                                    fontSize: AppFontSize.size_12,
                                    color: Colors.white.withOpacity(.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.18),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(.28),
                                    ),
                                  ),
                                  child: Text(
                                    role,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _GlassIconBtn(icon: Icons.edit, onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  _StatsRow(
                    items: const [
                      _StatItem(label: 'Orders', value: '124'),
                      _StatItem(label: 'Completed', value: '118'),
                      _StatItem(label: 'Rating', value: '4.9'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Contact',
                    rows: const [
                      _KVT('Email', 'example@company.com'),
                      _KVT('Phone', '+966 5 5555 5555'),
                      _KVT('Office', 'HQ / Ground'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Preferences',
                    rows: const [
                      _KVT('Language', 'Arabic'),
                      _KVT('Theme', 'System'),
                      _KVT('Notifications', 'Enabled'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ActionList(
                    items: [
                      _ActionTile(
                        icon: Icons.lock_outline,
                        text: 'Change Password',
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.notifications_outlined,
                        text: 'Notification Settings',
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.support_agent_outlined,
                        text: 'Support',
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.logout,
                        text: 'Logout',
                        danger: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderWaves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: AppColors.xprimaryColor)),
        Positioned.fill(
          child: Opacity(
            opacity: .12,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: CustomPaint(painter: _WavesPainter(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}

class _WavesPainter extends CustomPainter {
  final Color color;
  _WavesPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..lineTo(0, size.height * .65)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * 1.00,
        size.width,
        size.height * .70,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowAvatar extends StatelessWidget {
  final double size;
  final String? url;
  const _GlowAvatar({required this.size, this.url});
  @override
  Widget build(BuildContext context) {
    final img = url == null
        ? const CircleAvatar(radius: 28, child: Icon(Icons.person))
        : CircleAvatar(
            radius: size / 2 - 4,
            backgroundImage: NetworkImage(url!),
          );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(.55), width: 2),
      ),
      child: img,
    );
  }
}

class _GlassIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Material(
          color: Colors.white.withOpacity(.16),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<_StatItem> items;
  const _StatsRow({required this.items});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((e) => Expanded(child: _StatCard(item: e))).toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFE4DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            item.value,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_18,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_KVT> rows;
  const _InfoCard({required this.title, required this.rows});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.map((r) => _InfoRow(label: r.k, value: r.v)),
        ],
      ),
    );
  }
}

class _KVT {
  final String k, v;
  const _KVT(this.k, this.v);
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionList extends StatelessWidget {
  final List<_ActionTile> items;
  const _ActionList({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Column(children: items),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool danger;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.text,
    required this.onTap,
    this.danger = false,
  });
  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red : AppColors.black;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_14,
                  color: color,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}

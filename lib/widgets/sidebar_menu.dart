import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../providers/theme_provider.dart';
import 'uniloans_logo.dart';

class SidebarMenu extends ConsumerWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return Drawer(
      backgroundColor: AppColors.navy,
      width: 240,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const UniLoansAppIcon(size: 38),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UniLoans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                          Text('Your home loan partner', style: TextStyle(fontSize: 10, color: Color(0xFF7A9ACC))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          radius: 13,
                          child: Text('LO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Loan Officer', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                              Text('loan.officer@uniloans.in',
                                style: TextStyle(color: Color(0xFF7A9ACC), fontSize: 10),
                                overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Pro', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _Label('Quick actions'),
                  _Item(icon: Icons.home_outlined,        label: 'Home',             sub: 'Dashboard',           tag: null,    route: '/'),
                  _Item(icon: Icons.camera_alt_outlined,  label: 'New scan',         sub: 'Camera · auto-crop',  tag: 'Free',  route: '/camera'),
                  _Item(icon: Icons.folder_open,          label: 'Create new folder',sub: 'Organise by loan',    tag: 'Free',  route: null),
                  _Item(icon: Icons.import_export,        label: 'Import / Export',  sub: 'Drive, gallery, share',tag: null,   route: null),

                  const Divider(color: Colors.white12, indent: 14, endIndent: 14),
                  _Label('PDF tools'),
                  _Item(icon: Icons.picture_as_pdf,       label: 'PDF editor',       sub: 'Annotate, sign, merge',tag: 'Free', route: '/pdf-tools'),
                  _Item(icon: Icons.compare_arrows,       label: 'PDF converter',    sub: 'PDF ↔ image, Word',   tag: 'Free',  route: '/pdf-tools'),
                  _Item(icon: Icons.text_fields,          label: 'OCR text',         sub: 'Extract · 20+ langs', tag: 'Free',  route: null),

                  const Divider(color: Colors.white12, indent: 14, endIndent: 14),
                  _Label('Storage'),
                  _Item(icon: Icons.library_books_outlined, label: 'Document library', sub: 'All synced docs',   tag: null,   route: '/library'),
                  _Item(icon: Icons.delete_outline,       label: 'Recycle bin',      sub: '30-day retention',    tag: null,   route: '/recycle-bin'),

                  const Divider(color: Colors.white12, indent: 14, endIndent: 14),
                  _Label('App'),
                  _Item(icon: Icons.settings_outlined,    label: 'Settings',         sub: 'Theme, Drive, account',tag: null,  route: '/settings'),

                  // Dark mode toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                          child: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white70, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(isDark ? 'Dark mode' : 'Light mode',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                          activeColor: AppColors.blue,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Text('UniLoans v1.0.0 · Pro',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 3),
    child: Text(text.toUpperCase(),
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
        letterSpacing: 0.08, color: Colors.white.withOpacity(0.35))),
  );
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final String? tag, route;
  const _Item({required this.icon, required this.label, required this.sub, required this.tag, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (route != null && route != '/') {
          Navigator.pushNamed(context, route!);
        } else if (route == '/') {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.white70, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                  Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF7A9ACC))),
                ],
              ),
            ),
            if (tag != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0x3D1D9E75), borderRadius: BorderRadius.circular(20)),
                child: Text(tag!, style: const TextStyle(fontSize: 10, color: Color(0xFF5DCAA5))),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _Label('Appearance'),
          _Card(children: [
            SwitchListTile(
              secondary: Container(width: 34, height: 34,
                decoration: BoxDecoration(color: const Color(0xFFEEEDFE), borderRadius: BorderRadius.circular(9)),
                child: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF534AB7), size: 18)),
              title: Text(isDark ? 'Dark mode' : 'Light mode',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: const Text('Tap to switch theme', style: TextStyle(fontSize: 11)),
              value: isDark,
              activeColor: AppColors.navy,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
            ),
          ]),

          const SizedBox(height: 14),
          _Label('Storage'),
          _Card(children: [
            ListTile(
              leading: Container(width: 34, height: 34,
                decoration: BoxDecoration(color: const Color(0xFFFCEBEB), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.delete_outline, color: Color(0xFFA32D2D), size: 18)),
              title: const Text('Recycle bin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: const Text('Auto-delete after 30 days', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, '/recycle-bin'),
            ),
            const Divider(height: 0, indent: 57),
            ListTile(
              leading: Container(width: 34, height: 34,
                decoration: BoxDecoration(color: const Color(0xFFEEEDFE), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.cloud, color: Color(0xFF4285F4), size: 18)),
              title: const Text('Google Drive sync', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: const Text('Connected · auto-save on', style: TextStyle(fontSize: 11)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(20)),
                child: const Text('On', style: TextStyle(fontSize: 10, color: Color(0xFF085041), fontWeight: FontWeight.w500)),
              ),
            ),
          ]),

          const SizedBox(height: 14),
          _Label('Account'),
          _Card(children: [
            ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.navy, radius: 17,
                child: Text('LO', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))),
              title: const Text('Loan Officer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: const Text('loan.officer@uniloans.in', style: TextStyle(fontSize: 11)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(20)),
                child: const Text('Pro', style: TextStyle(color: Color(0xFFB0C8F0), fontSize: 10, fontWeight: FontWeight.w500)),
              ),
            ),
            const Divider(height: 0, indent: 57),
            ListTile(
              leading: Container(width: 34, height: 34,
                decoration: BoxDecoration(color: const Color(0xFFFCEBEB), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.logout, color: Color(0xFFA32D2D), size: 18)),
              title: const Text('Sign out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFA32D2D))),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 14),
          _Label('About'),
          _Card(children: [
            const ListTile(title: Text('Version', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), trailing: Text('1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey))),
            const Divider(height: 0, indent: 16),
            const ListTile(title: Text('UniLoans', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), subtitle: Text('Your Home Loan Partner', style: TextStyle(fontSize: 11))),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String t;
  const _Label(this.t);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 2),
    child: Text(t.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.07, color: Colors.grey.shade500)),
  );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(12)),
    child: Column(children: children),
  );
}

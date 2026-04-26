import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../providers/document_provider.dart';
import '../widgets/uniloans_logo.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/document_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(documentLibraryProvider);
    final top  = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.navy,
            padding: EdgeInsets.fromLTRB(16, top + 10, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: const Icon(Icons.menu, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 10),
                    const UniLoansAppIcon(size: 34),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UniLoans', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
                        Text('Your home loan partner', style: TextStyle(fontSize: 10, color: Color(0xFF8AAAD4))),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.cloud_done, color: Color(0xFF34A853), size: 12),
                          SizedBox(width: 4),
                          Text('Drive', style: TextStyle(color: Color(0xFFC0D8F8), fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white38, size: 16),
                      SizedBox(width: 8),
                      Text('Search loan documents...', style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatCard('${docs.length}', 'Total docs'),
                    const SizedBox(width: 10),
                    _StatCard('${docs.where((d) => d.isSynced).length}', 'Drive synced'),
                  ],
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Open sidebar button
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(7)),
                            child: const Icon(Icons.menu, color: Colors.white, size: 15),
                          ),
                          const SizedBox(width: 10),
                          const Text('Quick actions menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 12),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick action grid
                  _SectionLabel('Quick actions'),
                  const SizedBox(height: 6),
                  GridView.count(
                    crossAxisCount: 2, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8, mainAxisSpacing: 8,
                    childAspectRatio: 2.8,
                    children: [
                      _QA(icon: Icons.camera_alt,      label: 'New scan',    bg: const Color(0xFFE6F1FB), ic: const Color(0xFF185FA5), onTap: () => Navigator.pushNamed(context, '/camera')),
                      _QA(icon: Icons.folder_open,     label: 'New folder',  bg: const Color(0xFFEAF3DE), ic: const Color(0xFF3B6D11), onTap: () {}),
                      _QA(icon: Icons.picture_as_pdf,  label: 'PDF tools',   bg: const Color(0xFFFAEEDA), ic: const Color(0xFF854F0B), onTap: () => Navigator.pushNamed(context, '/pdf-tools')),
                      _QA(icon: Icons.delete_outline,  label: 'Recycle bin', bg: const Color(0xFFFCEBEB), ic: const Color(0xFFA32D2D), onTap: () => Navigator.pushNamed(context, '/recycle-bin')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SectionLabel('Recent documents'),
                  const SizedBox(height: 6),
                  ...docs.take(6).map((doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DocumentCard(doc: doc),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.navy,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/camera'),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 1) Navigator.pushNamed(context, '/camera');
          if (i == 2) Navigator.pushNamed(context, '/pdf-tools');
          if (i == 3) Navigator.pushNamed(context, '/settings');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.camera_alt_outlined), selectedIcon: Icon(Icons.camera_alt), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.picture_as_pdf_outlined), selectedIcon: Icon(Icons.picture_as_pdf), label: 'PDF'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF8AAAD4))),
      ]),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.07,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)));
}

class _QA extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg, ic;
  final VoidCallback onTap;
  const _QA({required this.icon, required this.label, required this.bg, required this.ic, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, color: ic, size: 15)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
      ]),
    ),
  );
}

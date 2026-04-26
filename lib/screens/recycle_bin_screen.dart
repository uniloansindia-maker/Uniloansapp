import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../providers/document_provider.dart';

class RecycleBinScreen extends ConsumerWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recycleBinProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Recycle Bin', style: TextStyle(color: Colors.white)),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmEmpty(context, ref),
              child: const Text('Empty all', style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              _Stat('${items.length}', 'items'),
              const SizedBox(width: 10),
              _Stat('27', 'days left'),
            ]),
          ),
          if (items.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFFAEEDA), borderRadius: BorderRadius.circular(9)),
              child: Row(children: [
                const Icon(Icons.info_outline, color: Color(0xFF633806), size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Items permanently deleted after 30 days',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade900))),
              ]),
            ),
          Expanded(
            child: items.isEmpty
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width: 56, height: 56,
                      decoration: const BoxDecoration(color: Color(0xFFFCEBEB), shape: BoxShape.circle),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFA32D2D), size: 28)),
                    const SizedBox(height: 12),
                    const Text('Recycle bin is empty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                  ]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final doc = items[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Container(width: 36, height: 46,
                          decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(4)),
                          child: const Icon(Icons.picture_as_pdf, color: AppColors.navy, size: 20)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(doc.borrowerName.isNotEmpty ? doc.borrowerName : doc.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                          if (doc.loanNumber.isNotEmpty)
                            Text(doc.loanNumber, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          Text('${DateTime.now().difference(doc.createdAt).inDays} days ago',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        ])),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            ref.read(documentLibraryProvider.notifier).addDocument(doc);
                            ref.read(recycleBinProvider.notifier).removeItem(doc.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document restored')));
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), backgroundColor: const Color(0xFFE6F1FB)),
                          child: const Text('Restore', style: TextStyle(color: Color(0xFF185FA5), fontSize: 11)),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Color(0xFFA32D2D), size: 20),
                          onPressed: () {
                            ref.read(recycleBinProvider.notifier).removeItem(doc.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permanently deleted')));
                          },
                          padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                        ),
                      ]),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _confirmEmpty(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Empty recycle bin?'),
        content: const Text('All items will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { ref.read(recycleBinProvider.notifier).clear(); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA32D2D)),
            child: const Text('Empty all', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String v, l;
  const _Stat(this.v, this.l);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        Text(l, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      ]),
    ),
  );
}

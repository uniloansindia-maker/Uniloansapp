import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../providers/document_provider.dart';

enum ScanFilter { original, magic, bw, grayscale, photo }

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});
  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  ScanFilter _filter = ScanFilter.magic;
  int _currentPage = 0;

  Color get _bgTint {
    switch (_filter) {
      case ScanFilter.magic:     return const Color(0xFFEEF3FB);
      case ScanFilter.bw:        return const Color(0xFFF2F2F2);
      case ScanFilter.grayscale: return const Color(0xFFF8F8F5);
      case ScanFilter.photo:     return const Color(0xFFFFFFF8);
      case ScanFilter.original:  return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(scanSessionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          pages.isEmpty ? 'Preview' : 'Preview · ${pages.length} page${pages.length > 1 ? "s" : ""}',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/camera'),
            child: const Text('+ Page', style: TextStyle(color: Color(0xFF8AAAD4))),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image preview area
          Expanded(
            child: Container(
              color: const Color(0xFFDDE3EE),
              child: Center(
                child: pages.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 80, color: Colors.white54),
                        SizedBox(height: 12),
                        Text('No pages scanned yet', style: TextStyle(color: Colors.white54)),
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _bgTint,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(File(pages[_currentPage]), fit: BoxFit.contain),
                      ),
                    ),
              ),
            ),
          ),

          // Page dots
          if (pages.length > 1)
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) => GestureDetector(
                  onTap: () => setState(() => _currentPage = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentPage ? 20 : 8, height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage ? AppColors.navy : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )),
              ),
            ),

          // Filter strip
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ScanFilter.values.map((f) {
                      final labels = {ScanFilter.original:'Original',ScanFilter.magic:'Magic color',ScanFilter.bw:'B&W',ScanFilter.grayscale:'Grayscale',ScanFilter.photo:'Photo'};
                      final sel = _filter == f;
                      return GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.navy : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sel ? AppColors.navy : Colors.grey.shade300),
                          ),
                          child: Text(labels[f]!,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                              color: sel ? Colors.white : Colors.grey.shade600)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.text_fields, size: 14),
                    label: const Text('OCR text', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 9)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: pages.isEmpty ? null : () => Navigator.pushNamed(context, '/loan-form'),
                    icon: const Icon(Icons.save_alt, size: 14, color: Colors.white),
                    label: const Text('Finalize & save', style: TextStyle(color: Colors.white, fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                    ),
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

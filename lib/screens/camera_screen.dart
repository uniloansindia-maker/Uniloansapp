import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import '../models/app_colors.dart';
import '../providers/document_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});
  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  bool _scanning = false;

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    try {
      final result = await FlutterDocScanner().getScanDocuments(page: 20);
      if (result != null && mounted) {
        final images = result['images'] as List<dynamic>? ?? [];
        final paths  = images.map((e) => e.toString()).toList();
        if (paths.isNotEmpty) {
          ref.read(scanSessionProvider.notifier).addPages(paths);
          Navigator.pushReplacementNamed(context, '/preview');
          return;
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan failed: ${e.message ?? "Unknown error"}')),
        );
      }
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111520),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text('UniLoans Scanner',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 240, height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF4A7FD4), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _scanning
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF4A7FD4)))
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.document_scanner, color: Color(0xFF4A7FD4), size: 64),
                              SizedBox(height: 12),
                              Text('Opening camera...',
                                style: TextStyle(color: Colors.white54, fontSize: 13)),
                            ],
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Align document within the frame',
                        style: TextStyle(color: Color(0xFF4A7FD4), fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              color: const Color(0xFF141820),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.photo_library, color: Colors.white60), onPressed: _startScan, iconSize: 28),
                  GestureDetector(
                    onTap: _scanning ? null : _startScan,
                    child: Container(
                      width: 68, height: 68,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                      child: Container(margin: const EdgeInsets.all(5), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.flash_auto, color: Colors.white60), onPressed: () {}, iconSize: 28),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF141820),
              padding: const EdgeInsets.only(bottom: 12),
              child: const Center(
                child: Text('Pro · auto-crop · up to 20 pages',
                  style: TextStyle(color: Color(0xFF4A7FD4), fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

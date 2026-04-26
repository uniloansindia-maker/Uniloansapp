import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class PdfToolsScreen extends StatelessWidget {
  const PdfToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('PDF Tools', style: TextStyle(color: Colors.white)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
            child: const Text('All Pro', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _Section('Convert', [
            _Tool(Icons.image,              const Color(0xFFE6F1FB), const Color(0xFF185FA5), 'PDF to Image',      'JPEG / PNG export',         'Free'),
            _Tool(Icons.picture_as_pdf,     const Color(0xFFEAF3DE), const Color(0xFF3B6D11), 'Image to PDF',      'Single or multi-image',     'Free'),
            _Tool(Icons.description,        const Color(0xFFFAEEDA), const Color(0xFF854F0B), 'PDF to Word',       '1/day free · unlimited Pro','Free'),
            _Tool(Icons.table_chart,        const Color(0xFFEEEDFE), const Color(0xFF534AB7), 'PDF to Excel',      '1/day free · unlimited Pro','Free'),
          ]),
          const SizedBox(height: 14),
          _Section('Edit', [
            _Tool(Icons.draw,               const Color(0xFFE1F5EE), const Color(0xFF0F6E56), 'Annotate & Markup', 'Draw, highlight, add text', 'Free'),
            _Tool(Icons.gesture,            const Color(0xFFFBEAF0), const Color(0xFF993556), 'E-Signature',       'Draw or import signature',  'Free'),
            _Tool(Icons.merge,              const Color(0xFFE6F1FB), const Color(0xFF185FA5), 'Merge / Split',     'Split free · merge Pro',    'Free'),
            _Tool(Icons.compress,           const Color(0xFFFAEEDA), const Color(0xFF854F0B), 'Compress PDF',      'Reduce file size',          'Free'),
            _Tool(Icons.rotate_right,       const Color(0xFFF1EFE8), const Color(0xFF5F5E5A), 'Rotate Pages',      'Any page, any direction',   'Free'),
            _Tool(Icons.add_box,            const Color(0xFFFCEBEB), const Color(0xFFA32D2D), 'Add / Remove Pages','Remove free · add Pro',     'Free'),
            _Tool(Icons.lock,               const Color(0xFFEEEDFE), const Color(0xFF534AB7), 'Password Protect',  'Pro only',                  'Pro'),
            _Tool(Icons.water,              const Color(0xFFE1F5EE), const Color(0xFF0F6E56), 'Watermark',         'Default free · custom Pro', 'Free'),
          ]),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(title.toUpperCase(),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.07, color: Colors.grey.shade500)),
      ),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: children.asMap().entries.map((e) => Column(children: [
            e.value,
            if (e.key < children.length - 1) Divider(height: 0, indent: 57, color: Theme.of(context).dividerColor),
          ])).toList(),
        ),
      ),
    ],
  );
}

class _Tool extends StatelessWidget {
  final IconData icon;
  final Color bg, ic;
  final String title, sub, tag;
  const _Tool(this.icon, this.bg, this.ic, this.title, this.sub, this.tag);
  @override
  Widget build(BuildContext context) {
    final isPro = tag == 'Pro';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
      leading: Container(width: 34, height: 34,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: ic, size: 17)),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      subtitle: Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: isPro ? AppColors.navy : const Color(0xFFE1F5EE),
          borderRadius: BorderRadius.circular(20)),
        child: Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
          color: isPro ? const Color(0xFFB0C8F0) : const Color(0xFF085041))),
      ),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title — coming soon'), duration: const Duration(seconds: 1))),
    );
  }
}

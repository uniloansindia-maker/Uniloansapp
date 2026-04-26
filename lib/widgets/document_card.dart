import 'package:flutter/material.dart';
import '../models/app_colors.dart';
import '../models/document_model.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel doc;
  const DocumentCard({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.navy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.borrowerName.isNotEmpty ? doc.borrowerName : doc.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                if (doc.loanNumber.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      doc.loanNumber,
                      style: const TextStyle(fontSize: 10, color: Color(0xFFB5CCF8)),
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  _formatDate(doc.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (doc.isSynced)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done, color: Color(0xFF085041), size: 11),
                  SizedBox(width: 3),
                  Text('Drive', style: TextStyle(fontSize: 10, color: Color(0xFF085041), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

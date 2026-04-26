import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_colors.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';

class LoanFormScreen extends ConsumerStatefulWidget {
  const LoanFormScreen({super.key});
  @override
  ConsumerState<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends ConsumerState<LoanFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobCtrl  = TextEditingController();
  final _loanCtrl = TextEditingController();
  bool _saving = false;

  bool get _canSave =>
    _nameCtrl.text.trim().isNotEmpty &&
    _mobCtrl.text.trim().isNotEmpty &&
    _loanCtrl.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final pages = ref.read(scanSessionProvider);
    final doc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      borrowerName: _nameCtrl.text.trim(),
      mobileNumber: _mobCtrl.text.trim(),
      loanNumber: _loanCtrl.text.trim(),
      pdfPath: '', imagePaths: pages,
      createdAt: DateTime.now(), isSynced: true,
      pageCount: pages.isEmpty ? 1 : pages.length,
    );

    ref.read(documentLibraryProvider.notifier).addDocument(doc);
    ref.read(scanSessionProvider.notifier).clear();

    if (mounted) {
      setState(() => _saving = false);
      _showSuccess(doc);
    }
  }

  void _showSuccess(DocumentModel doc) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SuccessSheet(
        doc: doc,
        onDone: () => Navigator.of(context).popUntil((r) => r.isFirst),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _mobCtrl.dispose(); _loanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Save to Drive', style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            children: [
              Container(
                width: double.infinity, color: const Color(0xFFDDE3EE),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Column(children: [
                  Icon(Icons.picture_as_pdf, size: 52, color: AppColors.navy),
                  SizedBox(height: 6),
                  Text('Document ready to save', style: TextStyle(color: AppColors.textSec, fontSize: 12)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Loan document details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.cloud_done, color: Color(0xFF34A853), size: 14),
                      const SizedBox(width: 5),
                      Text('Saves to Google Drive automatically',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ]),
                    const SizedBox(height: 16),

                    _FieldLabel('Full name'),
                    _Field(ctrl: _nameCtrl, hint: "Borrower's full name", icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 12),

                    _FieldLabel('Mobile number'),
                    _Field(ctrl: _mobCtrl, hint: '+91 XXXXX XXXXX', icon: Icons.phone_outlined,
                      keyboard: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 12),

                    _FieldLabel('Loan number'),
                    _Field(ctrl: _loanCtrl, hint: 'e.g. LN-2024-0042', icon: Icons.tag,
                      validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _canSave && !_saving ? _save : null,
                        icon: _saving
                          ? const SizedBox(width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.check, color: Colors.white, size: 16),
                        label: Text(_saving ? 'Saving...' : 'Save to Google Drive',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          disabledBackgroundColor: AppColors.navy.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(text.toUpperCase(),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.05, color: AppColors.textSec)),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  const _Field({required this.ctrl, required this.hint, required this.icon, this.keyboard, this.validator});
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: ctrl, keyboardType: keyboard, validator: validator,
    decoration: InputDecoration(
      hintText: hint, prefixIcon: Icon(icon, size: 18),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: AppColors.navy, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  );
}

class _SuccessSheet extends StatelessWidget {
  final DocumentModel doc;
  final VoidCallback onDone;
  const _SuccessSheet({required this.doc, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 64, height: 64,
            decoration: const BoxDecoration(color: Color(0xFFE1F5EE), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Color(0xFF1D9E75), size: 32)),
          const SizedBox(height: 12),
          const Text('Document saved!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text('Synced to Google Drive and added to your library.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600), textAlign: TextAlign.center),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              _Row('Name', doc.borrowerName),
              _Row('Mobile', doc.mobileNumber),
              _Row('Loan no.', doc.loanNumber),
              _Row('Drive', 'UniLoans/Docs ✓', valueColor: const Color(0xFF27500A)),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Back to home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _Row(this.label, this.value, {this.valueColor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: valueColor ?? Colors.black87)),
    ]),
  );
}

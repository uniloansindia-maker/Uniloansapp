import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document_model.dart';

// Current scan session pages
final scanSessionProvider =
    StateNotifierProvider<ScanSessionNotifier, List<String>>((ref) {
  return ScanSessionNotifier();
});

class ScanSessionNotifier extends StateNotifier<List<String>> {
  ScanSessionNotifier() : super([]);
  void addPages(List<String> paths) => state = [...state, ...paths];
  void removePage(int index) => state = [...state]..removeAt(index);
  void clear() => state = [];
}

// Document library
final documentLibraryProvider =
    StateNotifierProvider<DocumentLibraryNotifier, List<DocumentModel>>((ref) {
  return DocumentLibraryNotifier();
});

class DocumentLibraryNotifier extends StateNotifier<List<DocumentModel>> {
  DocumentLibraryNotifier() : super(_sampleDocs());
  void addDocument(DocumentModel doc) => state = [doc, ...state];
  void removeDocument(String id) =>
      state = state.where((d) => d.id != id).toList();
  void markSynced(String id) {
    state = state
        .map((d) => d.id == id ? d.copyWith(isSynced: true) : d)
        .toList();
  }
}

// Recycle bin
final recycleBinProvider =
    StateNotifierProvider<RecycleBinNotifier, List<DocumentModel>>((ref) {
  return RecycleBinNotifier();
});

class RecycleBinNotifier extends StateNotifier<List<DocumentModel>> {
  RecycleBinNotifier() : super(_sampleBin());
  void addItem(DocumentModel doc) => state = [doc, ...state];
  void removeItem(String id) =>
      state = state.where((d) => d.id != id).toList();
  void clear() => state = [];
}

List<DocumentModel> _sampleDocs() => [
  DocumentModel(
    id: '1', name: 'Rajesh Kumar Sharma',
    borrowerName: 'Rajesh Kumar Sharma',
    mobileNumber: '+91 98765 43210',
    loanNumber: 'LN-2024-0041',
    pdfPath: '', imagePaths: [],
    createdAt: DateTime.now(), isSynced: true, pageCount: 2,
  ),
  DocumentModel(
    id: '2', name: 'Priya Venkatesh Sharma',
    borrowerName: 'Priya Venkatesh Sharma',
    mobileNumber: '+91 87654 32109',
    loanNumber: 'LN-2024-0039',
    pdfPath: '', imagePaths: [],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    isSynced: true, pageCount: 4,
  ),
  DocumentModel(
    id: '3', name: 'Arun Kumar Selvam',
    borrowerName: 'Arun Kumar Selvam',
    mobileNumber: '+91 76543 21098',
    loanNumber: 'LN-2024-0035',
    pdfPath: '', imagePaths: [],
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isSynced: true, pageCount: 1,
  ),
];

List<DocumentModel> _sampleBin() => [
  DocumentModel(
    id: 'b1', name: 'Suresh Babu',
    borrowerName: 'Suresh Babu',
    mobileNumber: '+91 65432 10987',
    loanNumber: 'LN-2024-0021',
    pdfPath: '', imagePaths: [],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    pageCount: 2,
  ),
  DocumentModel(
    id: 'b2', name: 'Invoice draft Apr 2025',
    borrowerName: '', mobileNumber: '', loanNumber: '',
    pdfPath: '', imagePaths: [],
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    pageCount: 1,
  ),
];

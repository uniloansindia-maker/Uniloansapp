class DocumentModel {
  final String id;
  final String name;
  final String borrowerName;
  final String mobileNumber;
  final String loanNumber;
  final String pdfPath;
  final List<String> imagePaths;
  final DateTime createdAt;
  final bool isSynced;
  final int pageCount;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.borrowerName,
    required this.mobileNumber,
    required this.loanNumber,
    required this.pdfPath,
    required this.imagePaths,
    required this.createdAt,
    this.isSynced = false,
    this.pageCount = 1,
  });

  DocumentModel copyWith({
    String? borrowerName,
    String? mobileNumber,
    String? loanNumber,
    bool? isSynced,
  }) {
    return DocumentModel(
      id: id,
      name: name,
      borrowerName: borrowerName ?? this.borrowerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      loanNumber: loanNumber ?? this.loanNumber,
      pdfPath: pdfPath,
      imagePaths: imagePaths,
      createdAt: createdAt,
      isSynced: isSynced ?? this.isSynced,
      pageCount: pageCount,
    );
  }
}

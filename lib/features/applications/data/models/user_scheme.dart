import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScheme extends Equatable {
  final String recordId;
  final String userId;
  final String schemeId;
  final String status;
  final double matchScore;
  final DateTime? appliedAt;
  final String? applicationRef;
  final List<Document> documents;
  final DateTime lastUpdated;
  final String? rejectionReason;
  final String? approvalDetails;

  const UserScheme({
    required this.recordId,
    required this.userId,
    required this.schemeId,
    required this.status,
    required this.matchScore,
    this.appliedAt,
    this.applicationRef,
    required this.documents,
    required this.lastUpdated,
    this.rejectionReason,
    this.approvalDetails,
  });

  factory UserScheme.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final documentsList = data['documents'] as List<dynamic>? ?? [];

    return UserScheme(
      recordId: data['recordId'] as String,
      userId: data['userId'] as String,
      schemeId: data['schemeId'] as String,
      status: data['status'] as String,
      matchScore: (data['matchScore'] as num).toDouble(),
      appliedAt: data['appliedAt'] != null
          ? (data['appliedAt'] as Timestamp).toDate()
          : null,
      applicationRef: data['applicationRef'] as String?,
      documents: documentsList
          .map((doc) => Document(
                documentId: doc['documentId'] as String,
                type: doc['type'] as String,
                uploadedAt: (doc['uploadedAt'] as Timestamp).toDate(),
                storagePath: doc['storagePath'] as String,
                fileName: doc['fileName'] as String?,
              ))
          .toList(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      rejectionReason: data['rejectionReason'] as String?,
      approvalDetails: data['approvalDetails'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'recordId': recordId,
      'userId': userId,
      'schemeId': schemeId,
      'status': status,
      'matchScore': matchScore,
      'appliedAt': appliedAt != null ? Timestamp.fromDate(appliedAt!) : null,
      'applicationRef': applicationRef,
      'documents': documents
          .map((doc) => {
                'documentId': doc.documentId,
                'type': doc.type,
                'uploadedAt': Timestamp.fromDate(doc.uploadedAt),
                'storagePath': doc.storagePath,
                'fileName': doc.fileName,
              })
          .toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'rejectionReason': rejectionReason,
      'approvalDetails': approvalDetails,
    };
  }

  UserScheme copyWith({
    String? recordId,
    String? userId,
    String? schemeId,
    String? status,
    double? matchScore,
    DateTime? appliedAt,
    String? applicationRef,
    List<Document>? documents,
    DateTime? lastUpdated,
    String? rejectionReason,
    String? approvalDetails,
  }) {
    return UserScheme(
      recordId: recordId ?? this.recordId,
      userId: userId ?? this.userId,
      schemeId: schemeId ?? this.schemeId,
      status: status ?? this.status,
      matchScore: matchScore ?? this.matchScore,
      appliedAt: appliedAt ?? this.appliedAt,
      applicationRef: applicationRef ?? this.applicationRef,
      documents: documents ?? this.documents,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvalDetails: approvalDetails ?? this.approvalDetails,
    );
  }

  @override
  List<Object?> get props => [
        recordId,
        userId,
        schemeId,
        status,
        matchScore,
        appliedAt,
        applicationRef,
        documents,
        lastUpdated,
        rejectionReason,
        approvalDetails,
      ];
}

class Document extends Equatable {
  final String documentId;
  final String type;
  final DateTime uploadedAt;
  final String storagePath;
  final String? fileName;

  const Document({
    required this.documentId,
    required this.type,
    required this.uploadedAt,
    required this.storagePath,
    this.fileName,
  });

  @override
  List<Object?> get props => [documentId, type, uploadedAt, storagePath, fileName];
}

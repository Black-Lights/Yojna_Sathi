import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scheme extends Equatable {
  final String schemeId;
  final String name;
  final String ministry;
  final String category;
  final String description;
  final Eligibility eligibility;
  final Benefits benefits;
  final String applicationProcess;
  final List<String> documentsRequired;
  final String officialLink;
  final DateTime? launchDate;
  final DateTime? deadline;
  final String source;
  final String? videoTutorialId;

  const Scheme({
    required this.schemeId,
    required this.name,
    required this.ministry,
    required this.category,
    required this.description,
    required this.eligibility,
    required this.benefits,
    required this.applicationProcess,
    required this.documentsRequired,
    required this.officialLink,
    this.launchDate,
    this.deadline,
    required this.source,
    this.videoTutorialId,
  });

  factory Scheme.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final eligibilityData = data['eligibility'] as Map<String, dynamic>;
    final benefitsData = data['benefits'] as Map<String, dynamic>;

    return Scheme(
      schemeId: data['schemeId'] as String,
      name: data['name'] as String,
      ministry: data['ministry'] as String,
      category: data['category'] as String,
      description: data['description'] as String,
      eligibility: Eligibility(
        minAge: eligibilityData['minAge'] as int?,
        maxAge: eligibilityData['maxAge'] as int?,
        incomeMax: eligibilityData['incomeMax'] as String?,
        categories: List<String>.from(eligibilityData['categories'] ?? []),
        occupations: List<String>.from(eligibilityData['occupations'] ?? []),
        states: List<String>.from(eligibilityData['states'] ?? []),
        education: List<String>.from(eligibilityData['education'] ?? []),
      ),
      benefits: Benefits(
        amount: (benefitsData['amount'] as num?)?.toDouble(),
        type: benefitsData['type'] as String,
        frequency: benefitsData['frequency'] as String?,
        description: benefitsData['description'] as String,
      ),
      applicationProcess: data['applicationProcess'] as String,
      documentsRequired: List<String>.from(data['documentsRequired'] ?? []),
      officialLink: data['officialLink'] as String,
      launchDate: data['launchDate'] != null
          ? (data['launchDate'] as Timestamp).toDate()
          : null,
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      source: data['source'] as String,
      videoTutorialId: data['videoTutorialId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'schemeId': schemeId,
      'name': name,
      'ministry': ministry,
      'category': category,
      'description': description,
      'eligibility': {
        'minAge': eligibility.minAge,
        'maxAge': eligibility.maxAge,
        'incomeMax': eligibility.incomeMax,
        'categories': eligibility.categories,
        'occupations': eligibility.occupations,
        'states': eligibility.states,
        'education': eligibility.education,
      },
      'benefits': {
        'amount': benefits.amount,
        'type': benefits.type,
        'frequency': benefits.frequency,
        'description': benefits.description,
      },
      'applicationProcess': applicationProcess,
      'documentsRequired': documentsRequired,
      'officialLink': officialLink,
      'launchDate': launchDate != null ? Timestamp.fromDate(launchDate!) : null,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'source': source,
      'videoTutorialId': videoTutorialId,
    };
  }

  @override
  List<Object?> get props => [
        schemeId,
        name,
        ministry,
        category,
        description,
        eligibility,
        benefits,
        applicationProcess,
        documentsRequired,
        officialLink,
        launchDate,
        deadline,
        source,
        videoTutorialId,
      ];
}

class Eligibility extends Equatable {
  final int? minAge;
  final int? maxAge;
  final String? incomeMax;
  final List<String> categories;
  final List<String> occupations;
  final List<String> states;
  final List<String> education;

  const Eligibility({
    this.minAge,
    this.maxAge,
    this.incomeMax,
    required this.categories,
    required this.occupations,
    required this.states,
    required this.education,
  });

  @override
  List<Object?> get props => [
        minAge,
        maxAge,
        incomeMax,
        categories,
        occupations,
        states,
        education,
      ];
}

class Benefits extends Equatable {
  final double? amount;
  final String type;
  final String? frequency;
  final String description;

  const Benefits({
    this.amount,
    required this.type,
    this.frequency,
    required this.description,
  });

  @override
  List<Object?> get props => [amount, type, frequency, description];
}

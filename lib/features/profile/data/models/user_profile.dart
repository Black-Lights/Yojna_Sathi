import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends Equatable {
  final String userId;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String income;
  final String occupation;
  final String category;
  final String education;
  final List<String> specialConditions;
  final UserLocation location;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.income,
    required this.occupation,
    required this.category,
    required this.education,
    required this.specialConditions,
    required this.location,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final profile = data['profile'] as Map<String, dynamic>;
    final locationData = profile['location'] as Map<String, dynamic>;

    return UserProfile(
      userId: data['userId'] as String,
      name: profile['name'] as String,
      age: profile['age'] as int,
      gender: profile['gender'] as String,
      email: profile['email'] as String,
      phone: profile['phone'] as String,
      income: profile['income'] as String,
      occupation: profile['occupation'] as String,
      category: profile['category'] as String,
      education: profile['education'] as String,
      specialConditions: List<String>.from(profile['specialConditions'] ?? []),
      location: UserLocation(
        state: locationData['state'] as String,
        district: locationData['district'] as String,
        village: locationData['village'] as String? ?? '',
        latitude: (locationData['latitude'] as num?)?.toDouble(),
        longitude: (locationData['longitude'] as num?)?.toDouble(),
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'profile': {
        'name': name,
        'age': age,
        'gender': gender,
        'email': email,
        'phone': phone,
        'income': income,
        'occupation': occupation,
        'category': category,
        'education': education,
        'specialConditions': specialConditions,
        'location': {
          'state': location.state,
          'district': location.district,
          'village': location.village,
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      },
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    int? age,
    String? gender,
    String? email,
    String? phone,
    String? income,
    String? occupation,
    String? category,
    String? education,
    List<String>? specialConditions,
    UserLocation? location,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      income: income ?? this.income,
      occupation: occupation ?? this.occupation,
      category: category ?? this.category,
      education: education ?? this.education,
      specialConditions: specialConditions ?? this.specialConditions,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        age,
        gender,
        email,
        phone,
        income,
        occupation,
        category,
        education,
        specialConditions,
        location,
        createdAt,
        lastUpdated,
      ];
}

class UserLocation extends Equatable {
  final String state;
  final String district;
  final String village;
  final double? latitude;
  final double? longitude;

  const UserLocation({
    required this.state,
    required this.district,
    required this.village,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [state, district, village, latitude, longitude];
}

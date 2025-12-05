/// User profile for personalization
class UserProfile {
  final String id;
  final List<String> languages;
  final String proficiencyLevel;
  final List<String> goals;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  UserProfile({
    required this.id,
    this.languages = const ['ja'],
    this.proficiencyLevel = 'A1',
    this.goals = const [],
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastActiveAt = lastActiveAt ?? DateTime.now();

  factory UserProfile.empty() {
    return UserProfile(id: 'default');
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      languages: (map['languages'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
      proficiencyLevel: map['proficiency_level'] as String,
      goals: (map['goals'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      lastActiveAt: DateTime.fromMillisecondsSinceEpoch(
        map['last_active'] as int,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'languages': languages.join(','),
      'proficiency_level': proficiencyLevel,
      'goals': goals.join(','),
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_active': lastActiveAt.millisecondsSinceEpoch,
    };
  }

  UserProfile copyWith({
    String? id,
    List<String>? languages,
    String? proficiencyLevel,
    List<String>? goals,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      languages: languages ?? this.languages,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}

/// CEFR language proficiency levels
class ProficiencyLevel {
  static const String a1 = 'A1';
  static const String a2 = 'A2';
  static const String b1 = 'B1';
  static const String b2 = 'B2';
  static const String c1 = 'C1';
  static const String c2 = 'C2';

  static const List<String> all = [a1, a2, b1, b2, c1, c2];

  static String description(String level) {
    switch (level) {
      case a1:
        return 'Beginner';
      case a2:
        return 'Elementary';
      case b1:
        return 'Intermediate';
      case b2:
        return 'Upper Intermediate';
      case c1:
        return 'Advanced';
      case c2:
        return 'Proficient';
      default:
        return 'Unknown';
    }
  }
}

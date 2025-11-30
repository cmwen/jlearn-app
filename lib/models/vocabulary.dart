class Vocabulary {
  final int? id;
  final String word;
  final String reading;
  final String meaning;
  final String? partOfSpeech;
  final String? exampleSentence;
  final String? exampleReading;
  final String? exampleTranslation;
  final String jlptLevel;
  final DateTime createdAt;

  Vocabulary({
    this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    this.partOfSpeech,
    this.exampleSentence,
    this.exampleReading,
    this.exampleTranslation,
    required this.jlptLevel,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
      'part_of_speech': partOfSpeech,
      'example_sentence': exampleSentence,
      'example_reading': exampleReading,
      'example_translation': exampleTranslation,
      'jlpt_level': jlptLevel,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      id: map['id'],
      word: map['word'],
      reading: map['reading'],
      meaning: map['meaning'],
      partOfSpeech: map['part_of_speech'],
      exampleSentence: map['example_sentence'],
      exampleReading: map['example_reading'],
      exampleTranslation: map['example_translation'],
      jlptLevel: map['jlpt_level'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

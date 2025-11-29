class VocabularyItem {
  final int id;
  final String word;
  final String reading;
  final String meaning;
  final String category;
  final int jlptLevel;

  VocabularyItem({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.category,
    required this.jlptLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
      'category': category,
      'jlpt_level': jlptLevel,
    };
  }

  factory VocabularyItem.fromMap(Map<String, dynamic> map) {
    return VocabularyItem(
      id: map['id'] as int,
      word: map['word'] as String,
      reading: map['reading'] as String,
      meaning: map['meaning'] as String,
      category: map['category'] as String,
      jlptLevel: map['jlpt_level'] as int,
    );
  }
}

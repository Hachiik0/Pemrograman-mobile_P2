class Note {
  static const Map<String, int> categoryColors = {
    'Pribadi': 0xFFFFF9C4,
    'Kuliah': 0xFFE1F5FE,
    'Pekerjaan': 0xFFE8F5E9,
    'Ide': 0xFFF3E5F5,
  };

  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final String category;
  final int color;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.category = 'Pribadi',
    this.color = 0xFFFFF9C4,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'created_at': createdAt,
        'category': category,
        'color': color,
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        createdAt:
            map['created_at'] as String? ?? DateTime.now().toIso8601String(),
        category: map['category'] as String? ?? 'Pribadi',
        color: map['color'] as int? ?? categoryColors['Pribadi']!,
      );
}

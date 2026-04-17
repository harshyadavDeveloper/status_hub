class TemplateModel {
  final String id;
  final String text;
  final List<String> gradientColors; // hex strings
  final String fontFamily;
  final String category;
  final String language;
  bool isFavorite;

  TemplateModel({
    required this.id,
    required this.text,
    required this.gradientColors,
    required this.fontFamily,
    required this.category,
    required this.language,
    this.isFavorite = false,
  });

  TemplateModel copyWith({
    String? text,
    List<String>? gradientColors,
    String? fontFamily,
    bool? isFavorite,
  }) {
    return TemplateModel(
      id: id,
      text: text ?? this.text,
      gradientColors: gradientColors ?? this.gradientColors,
      fontFamily: fontFamily ?? this.fontFamily,
      category: category,
      language: language,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'gradientColors': gradientColors,
        'fontFamily': fontFamily,
        'category': category,
        'language': language,
        'isFavorite': isFavorite,
      };

  factory TemplateModel.fromMap(Map<String, dynamic> map) => TemplateModel(
        id: map['id'],
        text: map['text'],
        gradientColors: List<String>.from(map['gradientColors']),
        fontFamily: map['fontFamily'],
        category: map['category'],
        language: map['language'],
        isFavorite: map['isFavorite'] ?? false,
      );
}
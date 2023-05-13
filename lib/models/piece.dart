class Piece {
  final String source;
  final String? title;
  final String? caption;
  bool isFavorite;

  Piece({
    required this.source,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  String get id => source;
}

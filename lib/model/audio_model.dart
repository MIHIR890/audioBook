class Audiobook {
  final String title;
  final String author;
  final String description;
  final String audioUrl;
  final String? coverImage; // Optional
  final int? duration;      // Optional

  Audiobook({
    required this.title,
    required this.author,
    required this.description,
    required this.audioUrl,
    this.coverImage, // Optional
    this.duration,   // Optional
  });

  factory Audiobook.fromJson(Map<String, dynamic> json) {
    return Audiobook(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      audioUrl: json['audioUrl'],
      coverImage: json['coverImage'], // Can be null
      duration: json['duration'],    // Can be null
    );
  }
}

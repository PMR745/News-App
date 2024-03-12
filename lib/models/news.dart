class News {
  final dynamic author;
  final dynamic title;
  final dynamic description;
  final dynamic url;
  final dynamic urlToImage;
  final dynamic dateOfPublished;

  News({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.dateOfPublished,
  });

  factory News.fromMap(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      dateOfPublished: json['publishedAt'],
    );
  }
}

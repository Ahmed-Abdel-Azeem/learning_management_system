class Author{
  final String name;
  final String? image;

  Author({required this.name, this.image});

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      name: json['name'] as String,
      image: json['image'] as String?,
    );
  }
}
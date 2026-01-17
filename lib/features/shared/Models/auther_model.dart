class Author {
  final String? name;
  final String? image;

  Author({this.name, this.image});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'image': image};
}

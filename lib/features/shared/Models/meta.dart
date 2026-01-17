class Meta {
  final int page;
  final int totalItems;
  final int totalPages;
  final int itemsPerPage;

  Meta({
    required this.page,
    required this.totalItems,
    required this.totalPages,
    required this.itemsPerPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      itemsPerPage: json['itemsPerPage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'totalItems': totalItems,
    'totalPages': totalPages,
    'itemsPerPage': itemsPerPage,
  };
}

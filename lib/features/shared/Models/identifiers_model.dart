class Identifiers {
  final String? googleStoreId;
  final String? appleStoreId;
  final String? slug;

  Identifiers({this.googleStoreId, this.appleStoreId, this.slug});

  factory Identifiers.fromJson(Map<String, dynamic> json) {
    return Identifiers(
      googleStoreId: json['google_store_id'],
      appleStoreId: json['apple_store_id'],
      slug: json['slug'],
    );
  }
}

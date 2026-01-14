import 'package:learning_management_system/features/shared/Models/auther_model.dart';
import 'after_purchase_model.dart';
import 'identifiers_model.dart';

class Course {
  final String id;
  final String title;
  final int? expires;
  final String? expiresType;
  final AfterPurchase? afterPurchase;
  final List<String> categories;
  final String? description;
  final String? label; //auther name
  final Author? author;
  final String? courseImage;
  final double originalPrice;
  final double discountPrice;
  final double finalPrice;
  final String dripFeed;
  final Identifiers identifiers;
  final String access; // course is free or paid
  final int created;
  final int modified;

  Course({
    required this.id,
    required this.title,
    this.expires,
    this.expiresType,
    this.afterPurchase,
    required this.categories,
    this.description,
    this.label,
    this.author,
    this.courseImage,
    required this.originalPrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.dripFeed,
    required this.identifiers,
    required this.access,
    required this.created,
    required this.modified,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      expires: json['expires'],
      expiresType: json['expiresType'],
      afterPurchase: json['afterPurchase'] != null
          ? AfterPurchase.fromJson(json['afterPurchase'])
          : null,
      categories: List<String>.from(json['categories'] ?? []),
      description: json['description'],
      label: json['label'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      courseImage: json['courseImage'],
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      discountPrice: (json['discount_price'] ?? 0).toDouble(),
      finalPrice: (json['final_price'] ?? 0).toDouble(),
      dripFeed: json['dripFeed'],
      identifiers: Identifiers.fromJson(json['identifiers']),
      access: json['access'],
      created: json['created'],
      modified: json['modified'],
    );
  }
}

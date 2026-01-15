import 'package:learning_management_system/features/shared/Models/course_item.dart';
import 'package:learning_management_system/features/shared/Models/meta.dart';

class CoursesResponse {
  final List<CourseItem> data;
  final Meta meta;

  CoursesResponse({required this.data, required this.meta});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseItem.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

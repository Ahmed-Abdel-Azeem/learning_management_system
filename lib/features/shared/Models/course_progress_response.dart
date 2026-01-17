import 'package:learning_management_system/features/shared/Models/course_progress.dart';
import 'package:learning_management_system/features/shared/Models/meta.dart';

class CourseProgressResponse {
  final List<CourseProgress> data;
  final Meta meta;

  CourseProgressResponse({required this.data, required this.meta});

  factory CourseProgressResponse.fromJson(Map<String, dynamic> json) {
    return CourseProgressResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseProgress.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

import 'package:learning_management_system/features/shared/Models/course.dart';

class CourseItem {
  final int created;
  final int? expires;
  final Course course;

  CourseItem({required this.created, this.expires, required this.course});

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      created: json['created'],
      expires: json['expires'],
      course: Course.fromJson(json['course']),
    );
  }
}

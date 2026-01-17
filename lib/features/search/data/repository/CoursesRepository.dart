import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';

//Use to call Api Service then map response to model
class CoursesRepository {
  final HomeCoursesService service;

  CoursesRepository(this.service);

  Future<List<Course>> getAllCourses() async {
    final response = await service.getAllCourses();

    return (response.data['data'] as List)
        .map((e) => Course.fromJson(e))
        .toList();
  }
}

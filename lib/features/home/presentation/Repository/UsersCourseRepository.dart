import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/features/home/presentation/viewModel/CourseUsersViewModel.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class UsersCourseRepository {
  final HomeCoursesService service;
  UsersCourseRepository(this.service);

  Future<CourseUsersViewModel> getCourseWithUsersCount(String courseId) async {
    final course = await service.getAcourse(courseId);
    final usersCount = await service.getCourseUsersOnlyCount(courseId);

    return CourseUsersViewModel(course: course, usersCount: usersCount);
  }

  Future<List<CourseUsersViewModel>> getCoursesWithUsersCount() async {
    final response = await service.getAllCourses();

    final courses = (response.data['data'] as List)
        .map((e) => Course.fromJson(e))
        .toList();
    /*
        final List<CourseUsersViewModel> result = [];
        for (final course in courses) {
          final count = await service.getCourseUsersOnlyCount(course.id);
          result.add(CourseUsersViewModel(course: course, usersCount: count));
        return result;
    }*/
    return Future.wait(
      courses.map((course) async {
        final count = await service.getCourseUsersOnlyCount(course.id);
        return CourseUsersViewModel(course: course, usersCount: count);
      }),
    );
  }
}

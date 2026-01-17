import 'package:dio/dio.dart';
import 'package:learning_management_system/features/courses/data/constants/api_constants.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class CourseApi{
  final Dio dio = Dio(BaseOptions(
    baseUrl: "https://suezcanal.learnworlds.com/admin/api/v2" ,
    headers: {
      'Authorization':'Bearer $bearerToken',
      'Accept' : 'application/json',
      'Lw-Client' : clientId,
    }
      ));


     Future <List <Course>> getCourses() async{
        final response = await dio.get('/courses');
        final List data = response.data['data'];
        return data.map((course) => Course.fromJson(course),).toList();

      }

}
import 'package:dio/dio.dart';
import 'package:learning_management_system/features/courses/data/constants/api_constants.dart';

class Api{

  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      "Accept": "application/json",
      "Lw-Client": clientId,
      "Authorization": "Bearer $bearerToken"
    }
  ));
}
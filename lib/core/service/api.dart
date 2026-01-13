import 'package:dio/dio.dart';
import 'package:learning_management_system/core/constants/path.dart';

class ApiService {
  late final Dio dio;
  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Accept": "application/json",
          "Lw-Client": clientId,
          "Authorization": "Bearer $bearerToken",
        },
      ),
    );
  }
}

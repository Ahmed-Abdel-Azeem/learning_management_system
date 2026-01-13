import 'package:dio/dio.dart';
import 'package:learning_management_system/core/constants/path.dart';

class ApiService {
  final Dio _dio = Dio(
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

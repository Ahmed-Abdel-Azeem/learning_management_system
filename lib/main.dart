import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/CourseService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
//import 'features/home/presentation/screens/basic_home_page.dart';
import 'splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => CourseDataCubit(CourseService(ApiService())),
        child: CourseDetailScreen(courseId: 'stress-and-time-management'),
      ),
    );
  }
}

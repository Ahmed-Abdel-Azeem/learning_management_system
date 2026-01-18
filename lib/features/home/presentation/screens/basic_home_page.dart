import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/features/courses/data/api/course_api.dart';
import 'package:learning_management_system/features/courses/presentation/courses_view.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/search/data/repository/CoursesRepository.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';

import '../../../../theme/app_theme.dart';
import '../../../courses/presentation/progress_page.dart';
import '../../../search/presentation/search_page.dart';
import '../../../user/presentation/screens/profile_page.dart';
import 'home_body.dart';

class BaseHome extends StatefulWidget {
  const BaseHome({super.key, required this.title});

  final String title;

  @override
  State<BaseHome> createState() => _BaseHomeState();
}

class _BaseHomeState extends State<BaseHome> {
  int _currentIndex = 0;
  // ✅ Updated screens with BlocProvider for HomeBody
  late final List<Widget> _screens = [
    BlocProvider(
      create: (_) => CourseCubit(CourseApi())..loadCourses(),
      child: HomeBody(username: 'userName'),
      // child: HomeBody(username: 'userName'),
      //child: CourseViewPage(),
    ),
    ProgressPage(),
    BlocProvider(
      create: (_) =>
          SearchCubit(CoursesRepository(HomeCoursesService(ApiService()))),
      child: SearchPage(),
    ),
    ProfilePage(title: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = AppColors.primarySwatch;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.visible,
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: fontFamily),
        ),
        elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.shade500, scheme.shade700, scheme.shade900],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          ),
        ),)
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.border,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.textSecondary,
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'progress',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
    );
  }
}

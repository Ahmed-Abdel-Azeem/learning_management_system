import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/presentation/screens/user_progress_screen.dart';
import 'package:learning_management_system/features/home/presentation/Repository/UsersCourseRepository.dart';
import 'package:learning_management_system/features/home/presentation/screens/cuibts/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/search/data/repository/CoursesRepository.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';

import '../../../../theme/app_theme.dart';
//import '../../../courses/presentation/ProgressPage.dart';
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
  late CoursesCubit _coursesCubit;
  final GlobalKey<ProgressPageState> _progressPageKey = GlobalKey<ProgressPageState>();

  @override
  void initState() {
    super.initState();
    _coursesCubit = CoursesCubit(
      UsersCourseRepository(HomeCoursesService(ApiService())),
    )..loadCourses('');
  }

  @override
  void dispose() {
    _coursesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = AppColors.primarySwatch;

    final List<Widget> _screens = [
      BlocProvider.value(
        value: _coursesCubit,
        child: HomeBody(
          username: context.read<UserProvider>().user?.username ?? '',
          onCourseEnrolled: () {
            _progressPageKey.currentState?.refreshData();
          },
        ),
      ),
      ProgressPage(key: _progressPageKey),
      BlocProvider(
        create: (_) =>
            SearchCubit(CoursesRepository(HomeCoursesService(ApiService()))),
        child: SearchPage(
          onCourseEnrolled: () {
            _progressPageKey.currentState?.refreshData();
          },
        ),
      ),
      ProfilePage(title: ''),
    ];

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.w600, fontFamily: fontFamily)),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.shade500, scheme.shade700, scheme.shade900],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          onTap: (index) {
            setState(() => _currentIndex = index);
            // Refresh data when navigating to tabs
            if (index == 0) {
              // Refresh home courses
              debugPrint('🔄 Refreshing home courses...');
              _coursesCubit.loadSuggestedCourses();
            } else if (index == 1) {
              // Refresh progress page
              debugPrint('🔄 Refreshing progress page...');
              _progressPageKey.currentState?.refreshData();
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

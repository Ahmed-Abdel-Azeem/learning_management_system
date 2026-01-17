import 'package:flutter/material.dart';
import 'package:learning_management_system/features/courses/presentation/screens/user_progress_screen.dart';

import '../../../../theme/app_theme.dart';
import '../../../search/presentation/search_page.dart';
import '../../../user/presentation/profile_page.dart';
import 'home_body.dart';

class BaseHome extends StatefulWidget {
  const BaseHome({super.key, required this.title});

  final String title;

  @override
  State<BaseHome> createState() => _BaseHomeState();
}

class _BaseHomeState extends State<BaseHome> {
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    HomeBody(username: 'userName'),
    ProgressPage(),
    SearchPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.border,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.textSecondary,
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

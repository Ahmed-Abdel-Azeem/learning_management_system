import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/home/presentation/screens/cuibts/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/home/presentation/widgets/CourseGridView.dart';
import '../../../../theme/app_theme.dart';

class HomeBody extends StatefulWidget {
  final String username;
  final VoidCallback? onCourseEnrolled;
  
  const HomeBody({super.key, required this.username, this.onCourseEnrolled});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Future<void> _onRefresh() async {
    // Reload courses when user pulls to refresh
    context.read<CoursesCubit>().loadSuggestedCourses();
    // Wait a bit to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursesCubit, CoursesDataState>(
      listener: (context, state) {
        if (state is EnrollmentSuccess) {
          context.read<CoursesCubit>().loadSuggestedCourses();
        }
      },
      child: Column(
        children: [
          HeaderSection(username: widget.username),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Suggested for you', style: AppTextStyles.title),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CourseGridView(onCourseEnrolled: widget.onCourseEnrolled),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HEADER =================
class HeaderSection extends StatefulWidget {
  final String username;
  const HeaderSection({super.key, required this.username});

  @override
  State<HeaderSection> createState() => HeaderSectionState();
}

class HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    final scheme = AppColors.primarySwatch;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.shade500, scheme.shade700, scheme.shade900],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('lib/assets/images/logo1.png',
                  height: 60, width: 90),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Continue your learning journey',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
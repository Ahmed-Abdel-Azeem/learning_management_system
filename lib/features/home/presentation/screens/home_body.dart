import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:provider/provider.dart';

import '../../../../theme/app_theme.dart';
import '../../../shared/Models/auther_model.dart';
import '../../../shared/Models/course.dart';
import '../../../shared/Models/identifiers_model.dart';
import '../widgets/category_card.dart';
import '../widgets/course_card.dart';
import '../widgets/section_title.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.username});
  final String username;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<Course> courses = [];
  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    return Column(
      children: [
        HeaderSection(username: provider.user?.username ?? ''),
        const SizedBox(height: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Suggested For You'),
              const SizedBox(height: 12),
              Expanded(child: SuggestedList(courses: courses)),
              const SizedBox(height: 24),
              //  SectionTitle(title: 'Browse Categories'),
              //const SizedBox(height: 16),
              // CategoriesGrid(),
            ],
          ),
        ),
      ],
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
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.notifications_none, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ================= SUGGESTED LIST =================
class SuggestedList extends StatelessWidget {
  final List<Course> courses;
  final List<Color> categoryColors = AppColors.categoryColors;

  const SuggestedList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        List<Course> demoCourses = [];

        if (state is CourseLoaded) {
          demoCourses = state.courses;
        }

        if (state is CourseLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CourseFailure) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text(state.errorMessage)),
          );
        }

        if (demoCourses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No courses available')),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: demoCourses.length,
            physics: const AlwaysScrollableScrollPhysics(), // allow scrolling
            shrinkWrap: false, // take available space
            itemBuilder: (BuildContext context, int index) {
              final course = demoCourses[index];
              return CourseCard(
                title: course.title,
                category: course.categories.join(', '),
                author: course.author?.name ?? 'Unknown',
                color: categoryColors[index % categoryColors.length],
                image:
                    course.courseImage ??
                    'https://www.suezcanal.gov.eg/Style%20Library/Images/logo.png',
              );
            },
          ),
        );
      },
    );
  }
}

// ================= CATEGORIES =================
class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: const [
          CategoryCard('Development', '150 courses', Colors.blue, Icons.code),
          CategoryCard('Design', '89 courses', Colors.purple, Icons.palette),
          CategoryCard(
            'Business',
            '124 courses',
            Colors.green,
            Icons.trending_up,
          ),
          CategoryCard(
            'Photography',
            '67 courses',
            Colors.orange,
            Icons.camera_alt,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_analytic_cubit.dart';
import 'package:learning_management_system/features/courses/data/models/course_analytic_model.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/authorInfo.dart';
import 'package:learning_management_system/features/shared/Models/auther_model.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class Analytic extends StatelessWidget {
  const Analytic({super.key, required this.author, required this.label});
  final Author author;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseAnalyticCubit, CourseAnalyticState>(
      builder: (context, state) {
        if (state is CourseAnalyticLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CourseAnalyticLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCourseStats(state.analytic),
              const SizedBox(height: 10),
              AuthorInfo(author: author, label: label),
              const SizedBox(height: 10),
              _buildInfoGrid(state.analytic),
            ],
          );
        } else if (state is CourseAnalyticError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

Widget _buildCourseStats(CourseAnalyticModel courseAnalytic) {
  return Row(
    children: [
      // const Icon(Icons.star, color: Colors.amber, size: 20),
      // const SizedBox(width: 4),
      // const Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
      // const SizedBox(width: 4),
      // Text("(2.4k)", style: AppTextStyles.small),
      // const SizedBox(width: 16),
      Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 20),
      const SizedBox(width: 4),
      Text("${courseAnalytic.students} students", style: AppTextStyles.small),
    ],
  );
}

Widget _buildInfoGrid(CourseAnalyticModel courseAnalytic) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _infoCard(
        Icons.access_time_filled,
        "Total Duration",
        formatTime(courseAnalytic.totalStudyTime),
      ),
      _infoCard(
        Icons.library_books,
        "Lessons",
        courseAnalytic.learningUnits.toString(),
      ),
      _infoCard(Icons.workspace_premium, "Certificate", "Yes"),
    ],
  );
}

Widget _infoCard(IconData icon, String title, String value) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

String formatTime(int totalStudyTime) {
  final duration = Duration(seconds: totalStudyTime);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  // final secs = duration.inSeconds.remainder(60);
  return '${hours}h ${minutes}m ';
}

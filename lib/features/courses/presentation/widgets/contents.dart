import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_content_cubit.dart';
import 'package:learning_management_system/features/courses/data/models/course_content_model.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class Contents extends StatelessWidget {
  const Contents({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseContentCubit, CourseContentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: switch (state) {
            CourseContentLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CourseContentLoaded() => _buildContentList(state.content),
            CourseContentError() => Center(
              child: Text('Error: ${state.message}'),
            ),
          },
        );
      },
    );
  }

  Widget _buildContentList(CourseContentModel content) {
    return ListView(
      children: [
        Text('Course Contents', style: AppTextStyles.headline),
        const SizedBox(height: 12),
        ...content.sections.map(
          (section) => ExpansionTile(
            title: Text(section.title, style: AppTextStyles.title),
            children: section.learningUnits
                .map(
                  (lesson) => ListTile(
                    title: Text(lesson.title, style: AppTextStyles.body),
                    trailing: Text(
                      section.access == 'free' ? 'Free' : 'Paid',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

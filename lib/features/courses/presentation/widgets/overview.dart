import 'package:flutter/material.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class Overview extends StatelessWidget {
  const Overview({super.key, required this.desc, required this.categories});
  final String desc;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('Course Description', style: AppTextStyles.headline),
          const SizedBox(height: 12),
          Text(desc, style: AppTextStyles.body),
          const SizedBox(height: 20),
          Text('Categories', style: AppTextStyles.headline),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4.0,
            runSpacing: 8.0,
            children: categories
                .map(
                  (category) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary),
                      color: AppColors.primary.withAlpha(20),
                    ),
                    child: Text(category, style: AppTextStyles.body),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

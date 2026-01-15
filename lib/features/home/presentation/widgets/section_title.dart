import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.title,
          ),
          const Text(
            'See All',
            style: AppTextStyles.secondary,
          ),
        ],
      ),
    );
  }
}
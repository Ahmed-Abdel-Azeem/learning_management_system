import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class CourseCard extends StatelessWidget {
  final String title, category, author; // duration ;
  final Color? color;
  final String? image;

  const CourseCard({
    super.key,
    required this.title,
    required this.category,
    required this.author,
    // required this.duration,
    this.color,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              //edit here image from api
              child: Image.network(
                image ??
                    'https://www.suezcanal.gov.eg/Style%20Library/Images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.school, size: 40),
              ),
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: color ?? AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(author, style: AppTextStyles.small),
                    // const SizedBox(width: 8),
                    // Text(duration,
                    //     style: AppTextStyles.small),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

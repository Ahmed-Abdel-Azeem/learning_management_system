import 'package:flutter/material.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String title, subtitle;
  final Color color;
  final IconData icon;

  const CategoryCard(
    this.title,
    this.subtitle,
    this.color,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: AppTextStyles.smallWhite,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTextStyles.titleWhite
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}

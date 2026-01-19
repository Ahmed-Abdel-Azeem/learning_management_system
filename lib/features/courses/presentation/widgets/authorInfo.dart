import 'package:flutter/material.dart';
import 'package:learning_management_system/features/shared/Models/auther_model.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class AuthorInfo extends StatelessWidget {
  const AuthorInfo({super.key, required this.author, required this.label});
  final Author author;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(author.image!), radius: 30),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.title),
      ],
    );
  }
}

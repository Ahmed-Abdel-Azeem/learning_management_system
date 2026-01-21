import 'package:flutter/material.dart';
import 'package:learning_management_system/features/shared/Models/auther_model.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class AuthorInfo extends StatelessWidget {
  const AuthorInfo({super.key, this.author, required this.label});
  final Author? author;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: author?.image != null && author!.image!.isNotEmpty
              ? NetworkImage(author!.image!)
              : null,
          radius: 30,
          child: author?.image == null || author!.image!.isEmpty
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.title),
      ],
    );
  }
}

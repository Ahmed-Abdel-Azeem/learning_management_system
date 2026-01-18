import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/home/presentation/widgets/CourseGridView.dart';
import 'package:provider/provider.dart';

import '../../../../theme/app_theme.dart';
import '../../../shared/Models/auther_model.dart';
import '../../../shared/Models/course.dart';
import '../../../shared/Models/identifiers_model.dart';
import '../widgets/category_card.dart';
import '../widgets/course_card.dart';

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

              CourseGridView(),

              const SizedBox(height: 24),
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
          end: Alignment.topRight,
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

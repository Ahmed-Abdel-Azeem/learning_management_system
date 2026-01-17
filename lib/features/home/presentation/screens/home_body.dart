import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/presentation/courses_view.dart';
import '../../../courses/data/api/course_api.dart';
import '../../../courses/presentation/cubit/course_cubit.dart';
import '../../../courses/presentation/cubit/course_state.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseCubit(CourseApi())..loadCourses(),
      child: CustomScrollView(
        slivers: [
          // ===== Collapsible Top Section =====
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                'Hello $username',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                color: Colors.blue,
                // Optional: add decoration or image
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // ===== Sticky Suggested Title =====
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Suggested for you',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          // ===== Courses Grid =====
          BlocBuilder<CourseCubit, CourseState>(
            builder: (context, state) {
              if (state is CourseLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is CourseFailure) {
                return SliverFillRemaining(
                  child: Center(child: Text(state.errorMessage)),
                );
              }

              if (state is CourseLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = state.courses[index];
                        return CourseCard(course: course);
                      },
                      childCount: state.courses.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

// ===== Sticky Header Delegate =====
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

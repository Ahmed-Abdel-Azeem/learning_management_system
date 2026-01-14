import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/home/presentation/widgets/category_card.dart';
import 'package:learning_management_system/features/home/presentation/widgets/course_card.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_state.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';
import '../../../../theme/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // init data
    context.read<SearchCubit>().init();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<SearchCubit>().setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (_controller.text.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchCubit>().cancelSearch();
                  },
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),

        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchError) {
                return Center(child: Text(state.message));
              } else if (state is SearchCategoriesLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        context.read<SearchCubit>().selectCategory(category);
                      },
                      child: CategoryCard(
                        category,
                        'Courses under $category',
                        AppColors.primary,
                        Icons.category,
                      ),
                    );
                  },
                );
              } else if (state is SearchCourseLoaded) {
                final courses = state.courses;
                if (courses.isEmpty) {
                  return const Center(child: Text('No courses found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    var course = courses[index];
                    return CourseCard(
                      title: course.title,
                      category: course.categories.join(', '),
                      author: course.author?.name ?? 'Unknown',
                      image: course.courseImage,
                      color: AppColors.primary,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

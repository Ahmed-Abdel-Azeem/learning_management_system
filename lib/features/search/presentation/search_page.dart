import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:learning_management_system/features/home/presentation/widgets/category_card.dart';
import 'package:learning_management_system/features/home/presentation/widgets/course_card.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_state.dart';
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
    context.read<SearchCubit>().init();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> categoryColors = AppColors.categoryColors;
    var screenSize = MediaQuery.of(context).size;
    double childAspectRatio = screenSize.width < 600 ? 1.2 : 1.1;
    int crossAxisCount = screenSize.width < 600 ? 2 : 4;
    return Column(
      children: [
        ///  Search Bar
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
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controller.clear();
                              context.read<SearchCubit>().setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    context.read<SearchCubit>().setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(width: 8),

              /// Cancel Button
              /// Show only when there is text in the search field
              if (_controller.text.isNotEmpty)
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchCubit>().cancelSearch();
                  },
                  child: const Text('Cancel'),
                ),
            ],
          ),
        ),

        ///  Selected Category Chip
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchCourseLoaded &&
                !state.selectedCategory.toLowerCase().contains('all')) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(state.selectedCategory),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      context.read<SearchCubit>().clearCategory();
                    },
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),

        ///  Content
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SearchError) {
                return Center(child: Text(state.message));
              }

              /// Categories View
              if (state is SearchCategoriesLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        context.read<SearchCubit>().selectCategory(category);
                      },
                      child: CategoryCard(
                        category,
                        'Courses under ',
                        categoryColors[index % categoryColors.length],
                        Icons.category,
                      ),
                    );
                  },
                );
              }

              /// Courses View
              if (state is SearchCourseLoaded) {
                if (state.courses.isEmpty) {
                  return const Center(child: Text('No courses found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    return CourseCard(
                      title: course.title,
                      category: course.categories.join(', '),
                      author: course.author?.name ?? 'Unknown',
                      image: course.courseImage,
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                //CourseDetailsPage(course: state.courses[index]),
                                BlocProvider(
                                  create: (context) => CourseDataCubit(
                                    HomeCoursesService(ApiService()),
                                  ),
                                  child: CourseDetailScreen(
                                    courseId: course.id,
                                  ),
                                ),
                          ),
                        );
                      },
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

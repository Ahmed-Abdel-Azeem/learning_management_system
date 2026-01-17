import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/api/course_api.dart';
import 'package:learning_management_system/features/courses/presentation/courses_view.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  bool _showCourses = false;

  final List<Color> _categoryColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CourseCubit(CourseApi())..loadCourses(),
        ),
        BlocProvider(
          create: (_) => SearchCubit(),
        ),
      ],
      child: BlocListener<CourseCubit, CourseState>(
        listener: (context, state) {
          if (state is CourseLoaded) {
            // Initialize SearchCubit only after courses are loaded
            context.read<SearchCubit>().initCourses(state.courses);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Search Courses'),
            leading: _showCourses
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _showCourses = false;
                        _selectedCategory = null;
                        _searchController.clear();
                      });
                    },
                  )
                : null,
          ),
          body: Column(
            children: [
              _searchBar(context),
              Expanded(
                child: _showCourses
                    ? _searchResults()
                    : _categoriesGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Search Bar (Enter-only) =================
  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Builder(
        builder: (ctx) {
          return TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              // Only trigger search when user presses Enter
              ctx.read<SearchCubit>().searchCourses(query: value.trim());

              setState(() {
                _selectedCategory = null; // clear any selected category
                _showCourses = true;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= Categories Grid =================
  Widget _categoriesGrid() {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoaded) {
          final allCategories =
              state.courses.expand((c) => c.categories).toSet().toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 3,
            ),
            itemCount: allCategories.length,
            itemBuilder: (_, index) {
              final category = allCategories[index];
              final color = _categoryColors[index % _categoryColors.length];

              return GestureDetector(
                onTap: () {
                  context
                      .read<SearchCubit>()
                      .searchCourses(category: category);

                  setState(() {
                    _selectedCategory = category;
                    _showCourses = true;
                    _searchController.clear();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
        }

        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseFailure) {
          return Center(child: Text(state.errorMessage));
        }

        return const SizedBox();
      },
    );
  }

  // ================= Search Results =================
  Widget _searchResults() {
    return BlocBuilder<SearchCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoaded) {
          final courses = state.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('No courses found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: courses.length,
            itemBuilder: (_, i) {
              final course = courses[i];
              return CourseCard(course: course);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

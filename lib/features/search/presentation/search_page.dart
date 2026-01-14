import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:learning_management_system/features/search/presentation/cubit/search_cubit.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_state.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<SearchCubit>().init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<SearchCubit>().setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();

        List<Course> courses = [];
        List<String> categories = [];
        String selectedCategory = 'All categories';
        String searchQuery = '';

        if (state is SearchCategoriesLoaded) {
          categories = state.categories;
        } else if (state is SearchCourseLoaded) {
          courses = state.courses;
          categories = cubit.categories;
          selectedCategory = state.selectedCategory;
          searchQuery = state.searchQuery;
          _searchController.text = searchQuery;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Search Courses')),
          body: Column(
            children: [
              // Categories as clickable Cards
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _categoryCard(
                      'All categories',
                      selectedCategory == 'All categories',
                      cubit,
                    ),
                    ...categories.map(
                      (cat) =>
                          _categoryCard(cat, selectedCategory == cat, cubit),
                    ),
                  ],
                ),
              ),

              // Search bar (only if All categories selected)
              if (selectedCategory.toLowerCase() == 'all categories')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search courses...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                          cubit.cancelSearch();
                        },
                      ),
                    ],
                  ),
                ),

              // Courses list
              Expanded(
                child: state is SearchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : courses.isEmpty
                    ? const Center(child: Text('No courses found'))
                    : ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return ListTile(
                            title: Text(course.title),
                            subtitle: Text(course.categories.join(', ')),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryCard(String category, bool isSelected, SearchCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: GestureDetector(
        onTap: () => cubit.selectCategory(category),
        child: Card(
          color: isSelected ? Colors.blue : Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

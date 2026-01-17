import 'package:flutter/material.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchCategoriesLoaded extends SearchState {
  final List<String> categories;
  SearchCategoriesLoaded(this.categories);
}

class SearchCourseLoaded extends SearchState {
  final List<Course> courses;
  final String selectedCategory;
  final String searchQuery;
  final String message;

  SearchCourseLoaded({
    required this.courses,
    required this.selectedCategory,
    required this.searchQuery,
    required this.message,
  });
}

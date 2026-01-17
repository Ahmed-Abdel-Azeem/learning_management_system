import 'package:bloc/bloc.dart';
import 'package:learning_management_system/features/search/data/repository/CoursesRepository.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_state.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';

class SearchCubit extends Cubit<SearchState> {
  final CoursesRepository coursesRepository;

  List<Course> allCourses = [];
  List<String> categories = [];
  String selectedCategory = 'All categories';
  String searchQuery = '';

  SearchCubit(this.coursesRepository) : super(SearchInitial());

  /// init search page
  Future<void> init() async {
    emit(SearchLoading());

    try {
      allCourses = await coursesRepository.getAllCourses();
      categories = allCourses
          .expand((course) => course.categories)
          .toSet()
          .toList();
      emit(SearchCategoriesLoaded(categories));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    _filterCourses();
  }

  void setSearchQuery(String query) {
    searchQuery = query.trim().toLowerCase();
    /* if (searchQuery.isEmpty) {
      selectedCategory = 'All categories';
    }*/
    _filterCourses();
  }

  void clearCategory() {
    selectedCategory = 'All categories';
    searchQuery = '';
    emit(SearchCategoriesLoaded(categories));
  }

  void cancelSearch() {
    searchQuery = '';

    if (selectedCategory.toLowerCase().contains('all')) {
      emit(SearchCategoriesLoaded(categories));
    } else {
      _filterCourses();
    }
  }

  /// Search Criteria
  /// //1. course title
  /// //2. course's categories
  /// //3. course auther name
  /// //4. price
  /// //5. acess >> free ( if access is free then get all courses
  void _filterCourses() {
    final priceQuery = num.tryParse(searchQuery);
    List<Course> filtered = allCourses;
    if (filtered.isEmpty) return;

    emit(SearchLoading());

    try {
      // check if all categories
      final bool isAllCategories = selectedCategory.toLowerCase().contains(
        'all',
      );

      //filter by category
      if (!isAllCategories) {
        filtered = filtered
            .where(
              (course) => course.categories.any(
                (c) => c.toLowerCase() == selectedCategory.toLowerCase(),
              ),
            )
            .toList();
      }

      //fileter by search query
      if (searchQuery.isNotEmpty) {
        filtered = filtered
            .where(
              (course) =>
                  course.title.toLowerCase().contains(searchQuery) ||
                  // author name
                  (course.author?.name?.toLowerCase().contains(searchQuery) ??
                      false) ||
                  // access (free / paid)
                  (course.access.toLowerCase().contains(searchQuery) ||
                      (searchQuery == 'free' && course.finalPrice == 0)) ||
                  // price
                  (priceQuery != null &&
                      (course.finalPrice == priceQuery ||
                          course.originalPrice == priceQuery ||
                          course.discountPrice == priceQuery)) ||
                  // category (only if all categories)
                  (isAllCategories &&
                      course.categories.any(
                        (c) => c.toLowerCase().contains(searchQuery),
                      )),
            )
            .toList();
      }

      emit(
        SearchCourseLoaded(
          courses: filtered,
          selectedCategory: selectedCategory,
          searchQuery: searchQuery,
          message: filtered.isNotEmpty ? 'Results found' : 'No courses found',
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}

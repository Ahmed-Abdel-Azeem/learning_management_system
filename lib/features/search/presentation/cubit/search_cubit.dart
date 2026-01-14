import 'package:bloc/bloc.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/search/data/repository/CoursesRepository.dart';
import 'package:learning_management_system/features/search/presentation/cubit/search_state.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';
import 'package:meta/meta.dart';

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

  /*
  /// category click
  void selectCategory(String category) {
    selectedCategory = category;
    emit(SearchLoading());
    List<Course> filtered;
    try {
      if (category.toLowerCase().contains('all')) {
        filtered = allCourses;
      } else {
        final c = category.trim().toLowerCase();
        filtered = allCourses
            .where(
              (course) =>
                  course.categories.any((x) => x.toLowerCase().contains(c)),
            )
            .toList();
      }
      emit(
        SearchCourseLoaded(
          courses: filtered,
          message: 'Filtered by $selectedCategory',
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
    /// Search Criteria
  /// //1. course title
  /// //2. course's categories
  /// //3. course auther name >> label or auther.name
  /// //4. price
  /// //5. acess >> free ( if access is free then get all courses
  void searchCriteria(String searchQuery) {
    if (allCourses.isEmpty) return;
    if (searchQuery.isEmpty) {
      selectCategory(selectedCategory);
      return;
    }

    final query = searchQuery.trim().toLowerCase();
    final priceQuery = num.tryParse(query);

    emit(SearchLoading());
    try {
      final results = allCourses
          .where(
            (e) =>
                e.title.toLowerCase().contains(query) ||
                e.categories.any((c) => c.toLowerCase().contains(query)) ||
                (e.author != null &&
                        e.author!.name != null &&
                        e.author!.name!.toLowerCase().contains(query) ||
                    (e.label != null &&
                        e.label!.toLowerCase().contains(query))) ||
                (e.access.toLowerCase().contains(query) ||
                    (query == 'free' && e.finalPrice == 0)) ||
                (priceQuery != null &&
                    (e.finalPrice == priceQuery ||
                        e.originalPrice == priceQuery ||
                        e.discountPrice == priceQuery)),
          )
          .toList();

      emit(
        SearchCourseLoaded(
          courses: results.isNotEmpty ? results : allCourses,
          message: results.isNotEmpty
              ? 'Search results found'
              : 'No courses found for "$searchQuery"',
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
  */

  void selectCategory(String category) {
    selectedCategory = category;
    _filterCourses();
  }

  void setSearchQuery(String query) {
    searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      selectedCategory = 'All categories';
    }

    _filterCourses();
  }

  void cancelSearch() {
    searchQuery = '';
    selectedCategory = 'All categories';
    _filterCourses();
  }

  void _filterCourses() {
    final priceQuery = num.tryParse(searchQuery);
    List<Course> filtered = allCourses;
    if (filtered.isEmpty) return;
    emit(SearchLoading());
    try {
      //filter by category
      if (!selectedCategory.toLowerCase().contains('all')) {
        filtered = filtered
            .where(
              (course) => course.categories.any(
                (c) => c.toLowerCase().contains(selectedCategory.toLowerCase()),
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
                  course.categories.any(
                    (c) => c.toLowerCase().contains(searchQuery),
                  ) ||
                  (course.author?.name?.toLowerCase().contains(searchQuery) ??
                      false) ||
                  (course.label?.toLowerCase().contains(searchQuery) ??
                      false) ||
                  (course.access.toLowerCase().contains(searchQuery) ||
                      (searchQuery == 'free' && course.finalPrice == 0)) ||
                  (priceQuery != null &&
                      (course.finalPrice == priceQuery ||
                          course.originalPrice == priceQuery ||
                          course.discountPrice == priceQuery)),
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

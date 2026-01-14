part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Course> courses; //use in home screen
  final List<String> categories; //to use in search screen

  HomeLoaded(this.courses, this.categories);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

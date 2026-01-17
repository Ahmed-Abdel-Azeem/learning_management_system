import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_management_system/features/courses/data/api/course_api.dart';
import 'package:learning_management_system/features/courses/data/models/course_model.dart' show Course;
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:meta/meta.dart';


class CourseCubit extends Cubit<CourseState> {
  final CourseApi courseApi;
  CourseCubit(this.courseApi) : super(CourseInitial());

  List<Course> _allCourses = [];

  Future<void> loadCourses() async {
    
      emit(CourseLoading());
      try{
      _allCourses = await courseApi.getCourses();
        if(_allCourses.isEmpty){
          emit(CourseEmpty());
        }else{
          emit(CourseLoaded(_allCourses));
        }
      }
      catch(error){
      emit(CourseFailure( error.toString()));
    }
    }

    // Getter to provide all courses to other cubits

  List<Course> get allCourses => _allCourses;
    
}



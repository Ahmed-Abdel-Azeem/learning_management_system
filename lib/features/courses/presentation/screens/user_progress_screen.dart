import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/core/service/user_service.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:learning_management_system/features/shared/Models/course_progress_response.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';
import 'package:learning_management_system/features/shared/Models/identifiers_model.dart';
import 'package:learning_management_system/features/courses/presentation/course_details_page.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_theme.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  String selectedFilter = 'All Courses';
  final UserService _userService = UserService(ApiService());

  CourseProgressResponse? _progressData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFirstLoad = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchProgressData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _fetchProgressData();
    }
  }

  // Public method to refresh data from outside
  void refreshData() {
    _fetchProgressData();
  }

  Future<void> _fetchProgressData() async {
    final userProvider = context.read<UserProvider>();
    final userEmail = userProvider.user?.email;

    if (userEmail == null) {
      setState(() {
        _errorMessage = 'No user logged in';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _userService.getUserCourses(userEmail);
      setState(() {
        _progressData = response;
        _isLoading = false;
      });
      debugPrint('✅ Progress data loaded: ${response.data.length} courses');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      debugPrint('❌ Failed to load progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: RefreshIndicator(
        onRefresh: _fetchProgressData,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header Section
                Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.primarySwatch[700]!,
                        AppColors.primarySwatch[400]!,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and notification icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Progress',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Continue your learning journey',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primarySwatch[50]!,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Progress Circle
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(80, 216, 220, 223),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Progress',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFE8EFFF),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _progressData != null
                                        ? '${_calculateAverageProgress()}%'
                                        : '0%',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 90,
                                height: 90,
                                child: CustomPaint(
                                  painter: CircularProgressPainter(
                                    progress: _progressData != null
                                        ? _calculateAverageProgress() / 100
                                        : 0.0,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.25,
                                    ),
                                    progressColor: Colors.white,
                                    strokeWidth: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Row(
                    children: [
                      _buildStatCard(
                        Icons.menu_book_rounded,
                        _progressData != null
                            ? '${_progressData!.data.length}'
                            : '0',
                        'Courses',
                        AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.access_time,
                        _progressData != null
                            ? '${_calculateTotalTime()}h'
                            : '0h',
                        'Watched',
                        AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        Icons.check_circle_outline,
                        _progressData != null
                            ? '${_countCompletedCourses()}'
                            : '0',
                        'Completed',
                        AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Filter Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Row(
                    children: [
                      _buildFilterButton('All Courses'),
                      const SizedBox(width: 8),
                      _buildFilterButton('In Progress'),
                      const SizedBox(width: 8),
                      _buildFilterButton('Completed'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Course List - Dynamic from API
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: _progressData != null && _progressData!.data.isNotEmpty
                      ? Column(
                          children: [
                            ...List.generate(_progressData!.data.length, (
                              index,
                            ) {
                              final course = _progressData!.data[index];
                              final filteredByStatus = _shouldShowCourse(
                                course,
                              );

                              if (!filteredByStatus) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  _buildCourseCard(
                                    course: course,
                                    title: course.courseId,
                                    lessons: '${course.totalUnits} units',
                                    duration: _formatDuration(
                                      course.timeOnCourse,
                                    ),
                                    progress: course.totalUnits > 0
                                        ? course.completedUnits /
                                              course.totalUnits
                                        : 0.0,
                                    icon: _getRandomIcon(index),
                                    iconColor: _getRandomColor(index),
                                    isCompleted: course.status == 'completed',
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),
                            const SizedBox(height: 80),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 40),
                            Icon(
                              Icons.school_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isLoading
                                  ? 'Loading courses...'
                                  : 'No courses found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for calculating statistics from API data
  int _calculateAverageProgress() {
    if (_progressData == null || _progressData!.data.isEmpty) return 0;
    final total = _progressData!.data.fold<int>(
      0,
      (sum, course) => sum + course.progressRate,
    );
    return (total / _progressData!.data.length).round();
  }

  int _calculateTotalTime() {
    if (_progressData == null || _progressData!.data.isEmpty) return 0;
    final totalSeconds = _progressData!.data.fold<int>(
      0,
      (sum, course) => sum + course.timeOnCourse,
    );
    return (totalSeconds / 3600).round(); // Convert seconds to hours
  }

  int _countCompletedCourses() {
    if (_progressData == null || _progressData!.data.isEmpty) return 0;
    return _progressData!.data
        .where((course) => course.status == 'completed')
        .length;
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  // Random icon and color selection for variety
  IconData _getRandomIcon(int index) {
    final icons = [
      Icons.code,
      Icons.palette_outlined,
      Icons.phone_android,
      Icons.storage,
      Icons.brush,
      Icons.computer,
      Icons.science,
      Icons.menu_book,
      Icons.build,
      Icons.language,
    ];
    return icons[index % icons.length];
  }

  Color _getRandomColor(int index) {
    final colors = [
      AppColors.primary,
      const Color.fromARGB(255, 109, 38, 240),
      const Color.fromARGB(255, 136, 123, 2),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
    ];
    return colors[index % colors.length];
  }

  bool _shouldShowCourse(dynamic course) {
    if (selectedFilter == 'All Courses') return true;
    if (selectedFilter == 'Completed') return course.status == 'completed';
    if (selectedFilter == 'In Progress') return course.status != 'completed';
    return true;
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(41, 1, 111, 254),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 26),
            ),

            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: Color(0xFF123785),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : const Color.fromARGB(28, 177, 177, 177),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required dynamic course,
    required String title,
    required String lessons,
    required String duration,
    required double progress,
    required IconData icon,
    required Color iconColor,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 33),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$lessons • $duration',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                iconColor,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Create a Course object from progress data
                final courseObj = Course(
                  id: course.courseId,
                  title: course.courseId,
                  categories: [],
                  originalPrice: 0.0,
                  discountPrice: 0.0,
                  finalPrice: 0.0,
                  dripFeed: '',
                  identifiers: Identifiers(slug: course.courseId),
                  access: 'free',
                  created: 0,
                  modified: 0,
                );

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          CourseDataCubit(HomeCoursesService(ApiService())),
                      child: CourseDetailScreen(courseId: courseObj.id),
                    ),
                  ),
                );

                // Refresh data when returning from course detail
                _fetchProgressData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? const Color(0xFF4CAF50)
                    : AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCompleted ? Icons.check : Icons.play_arrow,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isCompleted ? 'Completed' : 'Continue Learning',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Circular Progress Painter for better control
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start from top
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

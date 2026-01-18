import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/core/service/user_service.dart';
import 'package:learning_management_system/features/shared/Models/course_progress_response.dart';
import 'package:learning_management_system/features/user/models/user_model.dart';
import 'package:learning_management_system/features/user/presentation/screens/login_page.dart';
import 'package:learning_management_system/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  CourseProgressResponse? courses;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserCourses();
  }

  Future<void> _loadUserCourses() async {
    final provider = context.read<UserProvider>();
    final user = provider.user;

    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final res = await UserService(_apiService).getUserCourses(user.email);
      if (!mounted) return;
      setState(() {
        courses = res;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('$st');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UserProvider>();
    final UserModel user = provider.user!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),

                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'lib/assets/images/profile.jpg',
                            fit: BoxFit.fill,
                            width: 120,
                            height: 120,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.school, size: 40),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.username ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontFamily,
                          ),
                        ),
                        SizedBox(height: 32),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' Personal information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.person,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          title: Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                          subtitle: Text(
                            user.username ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),

                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.mail,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          title: Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Learning stats",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          _loading
                                              ? '...'
                                              : '${courses?.data.length ?? 0}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamily,
                                          ),
                                        ),

                                        SizedBox(height: 4),
                                        Text(
                                          'Courses',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                        width: 24,
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          _loading
                                              ? '...'
                                              : totalLearningTimeHM(courses),
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Watch Time',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                        width: 24,
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          _loading
                                              ? '...'
                                              : '${completedCount(courses)}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Completed',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Consumer<UserProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : () {
                                        provider.logout();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                LoginPage(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(16),
                                            backgroundColor:
                                                Colors.green.shade600,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    "Logged out successfully!",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: provider.isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons
                                                .arrowRightFromBracket,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int completedCount(CourseProgressResponse? response) {
    if (response != null) {
      return response.data.where((c) => c.status == 'completed').length;
    } else {
      return 0;
    }
  }

  String totalLearningTimeHM(CourseProgressResponse? response) {
    if (response == null) return '0h 0m';

    final totalSeconds = response.data.fold<int>(
      0,
      (sum, c) => sum + c.timeOnCourse,
    );

    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return '${hours}h ${minutes}m';
  }
}

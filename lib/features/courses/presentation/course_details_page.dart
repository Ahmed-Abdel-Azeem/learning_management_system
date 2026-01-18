import 'package:flutter/material.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: const Color(0xFF0A2E6D),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            // Handle course start or registration (enrol to course )
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2E6D),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            course.access.toLowerCase() == 'free' ? "Start Course" : "Register",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 230,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child:
                      course.courseImage != null &&
                          course.courseImage!.isNotEmpty
                      ? Image.network(course.courseImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.white70,
                          ),
                        ),
                ),
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                course.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.author?.name ?? course.label ?? "Unknown",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    course.access.toLowerCase() == 'free' ? "Free" : "Paid",
                    style: TextStyle(
                      color: course.access.toLowerCase() == 'free'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "${course.finalPrice.toStringAsFixed(2)} EGP",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (course.discountPrice > 0)
                    Text(
                      "${course.originalPrice.toStringAsFixed(2)} EGP",
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  DetailItem(
                    icon: Icons.category,
                    title: "Categories",
                    value: course.categories.join(', '),
                  ),
                  DetailItem(
                    icon: Icons.person,
                    title: "Author",
                    value: course.author?.name ?? "Unknown",
                  ),
                  DetailItem(
                    icon: Icons.access_time,
                    title: "Expiry",
                    value: course.expires != null
                        ? "${course.expires} ${course.expiresType ?? ''}"
                        : "No expiry",
                  ),
                  DetailItem(
                    icon: Icons.lock_open,
                    title: "Access",
                    value: course.access,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Course Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                course.description ?? "No description available",
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

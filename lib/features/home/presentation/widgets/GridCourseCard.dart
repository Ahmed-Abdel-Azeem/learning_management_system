import 'package:flutter/material.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';
import 'package:learning_management_system/theme/app_theme.dart';
import 'dart:math';

class GridCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;
  final int participantsCount;

  const GridCourseCard({
    super.key,
    required this.course,
    required this.participantsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double randomDoubleOneDecimal() {
      final random = Random();
      double value = 3 + random.nextDouble() * 2; // 3.0 → 5.0
      return double.parse(value.toStringAsFixed(1));
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Column(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child:
                    course.courseImage != null && course.courseImage!.isNotEmpty
                    ? Image.network(course.courseImage!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.white70,
                          ),
                        ),
                      ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Author
                    if (course.author != null)
                      Text(
                        course.author!.name ?? 'Author',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      )
                    else
                      Text(
                        'Author',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    //nomber of participants
                    const SizedBox(height: 4),
                    // if (course.participants != null)
                    // Text(
                    //   course.participants ?? 'Author',
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    // )else
                    Text(
                      '$participantsCount  participants',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.secondary,
                    ),
                    Expanded(child: const SizedBox(height: 6)),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ElevatedButton(
                        //   onPressed: onTap,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xFF0A2E6D),
                        //     minimumSize: const Size(0, 36),
                        //     padding: const EdgeInsets.symmetric(horizontal: 10),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     'Register',
                        //     style: TextStyle(color: Colors.white, fontSize: 12),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              randomDoubleOneDecimal().toString(),
                              // course.rating != null
                              //     ? course.rating!.toStringAsFixed(1)
                              //     : '0.0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          course.access.toLowerCase() == 'free'
                              ? 'Free'
                              : course.access,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

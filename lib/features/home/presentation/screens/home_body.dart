import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../../shared/Models/auther_model.dart';
import '../../../shared/Models/course.dart';
import '../../../shared/Models/identifiers_model.dart';
import '../widgets/category_card.dart';
import '../widgets/course_card.dart';
import '../widgets/section_title.dart';



class HomeBody extends StatefulWidget {
  const HomeBody({super.key,required this.username});
  final String username;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<Course> courses = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderSection(username: widget.username,),
        const SizedBox(height: 16),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SectionTitle(title: 'Suggested For You'),
          const SizedBox(height: 12),
           SuggestedList(courses: courses,),
          const SizedBox(height: 24),
        //  SectionTitle(title: 'Browse Categories'),
          //const SizedBox(height: 16),
         // CategoriesGrid(),
          ],
          ),
        ),
      ],
    );
  }
}

// ================= HEADER =================
class HeaderSection extends StatefulWidget {
   final String username;
  const HeaderSection({super.key, required this.username});

  @override
  State<HeaderSection> createState() => HeaderSectionState();
}

class HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    final scheme = AppColors.primarySwatch;
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.shade500, scheme.shade700, scheme.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${widget.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Continue your learning journey',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),

      ],
    )
    );
  }
}


// ================= SUGGESTED LIST =================
class SuggestedList extends StatelessWidget {
  final List<Course> courses ;
  final List<Color> categoryColors= AppColors.categoryColors;

   const SuggestedList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    List<Course> demoCourses= [Course(id: '1', title: 'Mobile App Design Masterclass', categories: ['UI/UX Design'],
        originalPrice: 19.0, discountPrice: 19.0,
        finalPrice: 0, dripFeed: 'dripFeed',
        identifiers:Identifiers() , access: "free",
        courseImage: "https://lwfiles.mycourse.app/6860dbb646480f63e57aae11-public/3c6468b1ecda2ff53c61bde9629c04f4.png",
        created:  1751181311, modified: 1763361102 ,author:Author(name: 'Auther name')),
      Course(id: '1', title: 'Machine Learning Fundamentals', categories: ['AI & ML'],
          originalPrice: 19.0, discountPrice: 19.0,
          finalPrice: 0, dripFeed: 'dripFeed',
          identifiers:Identifiers() , access: "free",
          created:  1751181311, modified: 1763361102,author:Author(name: 'Auther name')),
      Course(id: '1', title: 'Python for Data Analysis', categories: ['Data Science'],
          originalPrice: 19.0, discountPrice: 19.0,
          finalPrice: 0, dripFeed: 'dripFeed',
          identifiers:Identifiers() , access: "free",
          created:  1751181311, modified: 1763361102, author:Author(name: 'Auther name')),
      Course(id: '1', title: 'Digital Marketing Strategy 2024', categories: ['Marketing'],
          originalPrice: 19.0, discountPrice: 19.0,
          finalPrice: 0, dripFeed: 'dripFeed',
          identifiers:Identifiers() , access: "free",
          created:  1751181311, modified: 1763361102, author:Author(name: 'Auther name')),
      // Course(id: '1', title: 'Python for Data Analysis', categories: ['Data Science'],
      //     originalPrice: 19.0, discountPrice: 19.0,
      //     finalPrice: 0, dripFeed: 'dripFeed',
      //     identifiers:Identifiers() , access: "free",
      //     created:  1751181311, modified: 1763361102, author:Author(name: 'Auther name')),
      // Course(id: '1', title: 'Machine Learning Fundamentals', categories: ['AI & ML'],
      //     originalPrice: 19.0, discountPrice: 19.0,
      //     finalPrice: 0, dripFeed: 'dripFeed',
      //     identifiers:Identifiers() , access: "free",
      //     created:  1751181311, modified: 1763361102,author:Author(name: 'Auther name')),
      Course(id: '1', title: 'Python for Data Analysis', categories: ['Data Science'],
          originalPrice: 19.0, discountPrice: 19.0,
          finalPrice: 0, dripFeed: 'dripFeed',
          identifiers:Identifiers() , access: "free",
          created:  1751181311, modified: 1763361102, author:Author(name: 'Auther name')),];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
        ListView.builder(
          itemCount: demoCourses.length,
          shrinkWrap: true,
         // physics: const NeverScrollableScrollPhysics(),// Optional: specifies the total number of items
          itemBuilder: (BuildContext context, int index) {
            return  CourseCard(
                  title: demoCourses[index].title,
                  category: demoCourses[index].categories.join(', '),
                  author: demoCourses[index].author!.name!,
                  color: categoryColors[index % categoryColors.length],
                  image: demoCourses[index].courseImage??'https://www.suezcanal.gov.eg/Style%20Library/Images/logo.png',

            );
          },
        )


    );
  }
}




// ================= CATEGORIES =================
class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: const [
          CategoryCard('Development', '150 courses', Colors.blue, Icons.code),
          CategoryCard('Design', '89 courses', Colors.purple, Icons.palette),
          CategoryCard('Business', '124 courses', Colors.green, Icons.trending_up),
          CategoryCard('Photography', '67 courses', Colors.orange, Icons.camera_alt),
        ],
      ),
    );
  }
}
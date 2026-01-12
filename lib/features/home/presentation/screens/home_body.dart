import 'package:flutter/material.dart';



class HomeBody extends StatelessWidget {
  const HomeBody({super.key,required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('hello $username'),
              const SizedBox(height: 20,),

            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import 'home/homepage.dart';

class Splashpage extends StatelessWidget {
  const Splashpage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Homepage()),
      ),
    );
    return Material(
      child: Container(
        color: Colors.grey[200],
        child: const Center(
          child: Text(
            'Attendance',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:attendance/home/details_page.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Welcome to app"),
      ),
      body: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DetailsPage(),
            ),
          );
        },
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]),
            child: const Center(
              child: Text(
                "Connect device",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

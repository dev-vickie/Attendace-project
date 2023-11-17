import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:attendance/models/lecturer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChartPage extends StatefulWidget {
  final Lecturer lecturer;
  const ChartPage({Key? key, required this.lecturer}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  // text controller for student name
  final studentController = TextEditingController();
  Box<String>? _studentsBox; // Declare a variable for the Box

  @override
  void initState() {
    super.initState();
    openBox(); // Call method to open the box
  }

  Future<void> openBox() async {
    _studentsBox = await Hive.openBox<String>(widget.lecturer.date);
    // Trigger a rebuild after opening the box
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _studentsBox == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //display the lecturer name and unit code
                Text(
                  "${widget.lecturer.name} ${widget.lecturer.unitCode}",
                  style: const TextStyle(fontSize: 20),
                ),
                //display the date
                Text(
                  widget.lecturer.date,
                  style: const TextStyle(fontSize: 20),
                ),
                //display the list of students
                Expanded(
                  child: ValueListenableBuilder<Box<String>>(
                    valueListenable:
                        _studentsBox!.listenable(), // Use the box here
                    builder: (context, Box<String> box, _) {
                      if (box.isEmpty) {
                        return Center(
                          child: Text('No students added yet.'),
                        );
                      }
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final student = box.getAt(index);
                          return ListTile(
                            title: Text(student!),
                          );
                        },
                      );
                    },
                  ),
                ),

                //textfield and a button to add a student
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter student name",
                        ),
                        controller: studentController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //add the student to the box
                        _studentsBox?.add(studentController.text.toString());
                        //clear the textfield
                        studentController.clear();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

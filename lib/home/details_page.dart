import 'package:attendance/home/chart_page.dart';
import 'package:attendance/models/lecturer.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    //text controllers for lecturer,unitcode,date and also a form key
    final lecturerController = TextEditingController();
    final unitcodeController = TextEditingController();
    final dateController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    @override
    void dispose() {
      lecturerController.dispose();
      unitcodeController.dispose();
      dateController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Enter Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  //text form field for lecturer
                  TextFormField(
                    controller: lecturerController,
                    decoration: const InputDecoration(
                      labelText: "Lecturer",
                      hintText: "Enter lecturer name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter lecturer name';
                      }
                      return null;
                    },
                  ),
                  //text form field for unit code
                  TextFormField(
                    controller: unitcodeController,
                    decoration: const InputDecoration(
                      labelText: "Unit Code",
                      hintText: "Enter unit code",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter unit code';
                      }
                      return null;
                    },
                  ),
                  //text form field for date
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      hintText: "Enter date",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //button to submit details
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(lecturerController.text);

                        // //navigate
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChartPage(
                              lecturer: Lecturer(
                                name: lecturerController.text,
                                unitCode: unitcodeController.text,
                                date: dateController.text,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

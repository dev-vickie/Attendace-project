import 'package:attendance/home/chart_page.dart';
import 'package:attendance/models/lecturer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      if (_formKey.currentState!.validate()) {
                        print(unitcodeController.text);
                        //open hive and check if a box exists with unit code as key
                        var box = await Hive.openBox(unitcodeController.text);
                        //if it doesn't exist, create a new box with unit code as key and an empty list as value,then add date to the list
                        if (box.isEmpty) {
                          box.put('dates', [DateTime.now().day.toString()]);
                        } else {
                          //if it exists, check if date is in the list
                          List<String> dates =
                              box.get('dates', defaultValue: []);
                          String currentDate = DateTime.now().day.toString();
                          //if it is, do nothing
                          //if it isn't, add date to the list
                          if (!dates.contains(currentDate)) {
                            dates.add(currentDate);
                            box.put('dates', dates);
                          }
                        }
                        //then navigate to chart page
                        nav.push(
                          MaterialPageRoute(
                            builder: (context) => ChartPage(
                              lecturer: Lecturer(
                                  name: lecturerController.text,
                                  unitCode: unitcodeController.text,
                                  date: DateTime.now().day.toString()),
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

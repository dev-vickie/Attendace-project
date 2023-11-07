import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:attendance/models/lecturer.dart';

class ChartPage extends StatefulWidget {
  final Lecturer lecturer;
  const ChartPage({Key? key, required this.lecturer}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final List<String> _regNos = ['001', '002', '003', '004', '005'];
  List<String> _dates = [];
  Box? _attendanceBox; // Nullable Hive box for storing attendance data

  TextEditingController _regNoController = TextEditingController();
  String _markedRegNo = '';

  @override
  void initState() {
    super.initState();
    _initializeAttendanceBox();
  }

  Future<void> _initializeAttendanceBox() async {
    _attendanceBox = await Hive.openBox('attendanceData');
    _initializeAttendanceData();
  }

  void _initializeAttendanceData() {
    // Get all available dates from the stored data
    Set<String> allDates = Set();

for (var regNo in _regNos) {
  var data = _attendanceBox!.get(regNo);
  if (data != null) {
    for (var key in data.keys) {
      if (key is String) {
        allDates.add(key);
      }
    }
  }
}


    // Sort the dates in ascending order
    _dates = allDates.toList()..sort();

    if (_dates.isNotEmpty) {
      // Set the initial date to the first available date
      _dates.insert(0, _dates[0]);

      for (var regNo in _regNos) {
        var data = _attendanceBox!.get(regNo);
        if (data == null) {
          data = {_dates[0]: 'x'};
        } else {
          for (var date in _dates) {
            data.putIfAbsent(date, () => 'x');
          }
        }
        _attendanceBox!.put(regNo, data);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _markAttendance() {
    final regNo = _regNoController.text;
    if (_regNos.contains(regNo)) {
      var data = _attendanceBox!.get(regNo);
      final currentDate =
          _dates[0]; // Get the current date for marking attendance

      if (data != null) {
        data[currentDate] = '✓';
        _attendanceBox!.put(regNo, data);
        setState(() {
          _markedRegNo = regNo;
        });
      }
    }
  }

  @override
  void dispose() {
    _attendanceBox!.close(); // Close the Hive box when leaving the page
    _regNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_attendanceBox == null || _dates.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Attendance Chart"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display lecturer's name and unit code
            Text(
              "Lecturer's name: ${widget.lecturer.name}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Unit Code: ${widget.lecturer.unitCode}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: <DataColumn>[
                  const DataColumn(label: Text('Reg No')),
                  for (var date in _dates)
                    DataColumn(
                      label: Text(date),
                    ),
                ],
                rows: _regNos
                    .map(
                      (regNo) => DataRow(
                        cells: [
                          DataCell(Text(regNo)),
                          for (var date in _dates)
                            DataCell(
                              Text(
                                _attendanceBox!.get(regNo)![date] ?? 'x',
                              ),
                            ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            // Display the TextField, "Mark Attendance" button, and the marked regNo
            TextField(
              controller: _regNoController,
              decoration: InputDecoration(labelText: 'Enter Reg No'),
            ),
            ElevatedButton(
              onPressed: _markAttendance,
              child: Text('Mark Attendance'),
            ),
            if (_markedRegNo.isNotEmpty)
              Text('Attendance marked for Reg No $_markedRegNo'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, dynamic> studentData = {};
  Map<dynamic, dynamic> timetableData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/TimetablePage');
    _fetchData();
  }

  Future<void> _fetchData() async {
    await fetchStudentData();
    if (studentData.isNotEmpty) {
      await fetchTimetableData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchStudentData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final email = user.email;
      final databaseRef = FirebaseDatabase.instance.ref('Students');

      final snapshot = await databaseRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        bool found = false;

        data.forEach((key, student) {
          if (student['collegeMail'] == email || student['personalMail'] == email) {
            setState(() {
              studentData = Map<String, dynamic>.from(student);
            });
            found = true;
          }
        });

        if (!found) {
          print('No matching student found');
        }
      } else {
        print('No data found in Firebase');
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  Future<void> fetchTimetableData() async {
    try {
      if (studentData.isNotEmpty) {
        int semester = int.tryParse(studentData['semester'].toString()) ?? 0;
        String specialization = studentData['specialization'];

        final databaseRefT = FirebaseDatabase.instance.ref('timetables/$semester/$specialization');
        final snapshot = await databaseRefT.get();

        if (snapshot.exists && snapshot.value != null) {
          setState(() {
            timetableData = snapshot.value as Map<dynamic, dynamic>;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          print('No timetable found for semester $semester and specialization $specialization');
        }
      }
    } catch (e) {
      print('Error fetching timetable: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(
            title: 'Time Table'
        ),
        backgroundColor: Color(0xFFCFE3DD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (timetableData.isEmpty) {
      return const Scaffold(
        appBar: CustomAppBar(
            title: 'Time Table'
        ),
        backgroundColor: Color(0xFFCFE3DD),
        body: Center(child: Text('No timetable available.')),
      );
    }

    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final todayWeekday = DateFormat('EEEE').format(today);
    final tomorrowWeekday = DateFormat('EEEE').format(tomorrow);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Time Table'
      ),
      backgroundColor: Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today: ${DateFormat('dd/MM/yyyy').format(today)} ($todayWeekday)',
              style: const TextStyle(color: Color(0xff026a75), fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (timetableData.containsKey(todayWeekday)) // Add this check
              ...(timetableData[todayWeekday]?.map((item) => _buildTimetableItem(item['time']!, item['subject']!))?.toList() ?? []),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Tomorrow: ${DateFormat('dd/MM/yyyy').format(tomorrow)} ($tomorrowWeekday)',
              style: const TextStyle(color: Color(0xff026a75), fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (timetableData.containsKey(tomorrowWeekday)) // Add this check
              ...(timetableData[tomorrowWeekday]?.map((item) => _buildTimetableItem(item['time']!, item['subject']!))?.toList() ?? []),
            const SizedBox(height: 24),
            /*Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to full timetable view
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('View Full Timetable'),
              ),
            ),*/ // Button to view the full time table
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableItem(String time, String subject) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0 * 2; // 16.0 padding on both sides

    return Container(
      width: screenWidth - horizontalPadding,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xffcfe3dd),
        borderRadius: BorderRadius.circular(8),
        boxShadow:[
          BoxShadow(
            color: Colors.grey, // Shadow color
            spreadRadius: 4, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(-1, 5), // Offset in x and y directions
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Color(0xff026a75))),
          const SizedBox(height: 4),
          Text(subject, style: const TextStyle(color: Color(0xff026a75), fontSize: 15,fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
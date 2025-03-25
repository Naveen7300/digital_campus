import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'timetable_page.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';
import 'events_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Map<String, dynamic> studentData = {};
  Map<dynamic, dynamic> timetableData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/HomePage');
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
  }

  void _openTimetable() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimetablePage()),
    );
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

  String getNextClassSubject(Map<dynamic, dynamic> timetableData) {
    final now = DateTime.now();
    final todayWeekday = DateFormat('EEEE').format(now);
    final currentTime = DateFormat('hh:mm a').parse(DateFormat('hh:mm a').format(now)); // Parse current time

    if (timetableData.containsKey(todayWeekday)) {
      final todayClasses = timetableData[todayWeekday] as List<dynamic>;

      // Sort classes by start time in 12-hour format
      todayClasses.sort((a, b) {
        final startTimeA = DateFormat('hh:mm a').parse(a['time'].split('-')[0]);
        final startTimeB = DateFormat('hh:mm a').parse(b['time'].split('-')[0]);
        return startTimeA.compareTo(startTimeB);
      });

      for (final classItem in todayClasses) {
        final startTime = DateFormat('hh:mm a').parse(classItem['time'].split('-')[0]);

        if (startTime.isAfter(currentTime)) {
          return classItem['subject']; // Return the next class
        }
      }

      // If all classes are over, return "No upcoming classes today."
      return 'No upcoming classes today.';
    }

    return 'No upcoming classes today.';
  }

  void _openAssignments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssignmentsPage()),
    );
  }

  /*
  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsPage()),
    );
  }
  */ // Navigation route to Notification Dash-Card

  void _openEvents() {
    // Implement your events opening logic here
    // For example:
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, User !',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff026A75),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  DashboardCard(
                    title: 'Upcoming Classes',
                    content: getNextClassSubject(timetableData),
                    onTap: _openTimetable,
                  ),
                  DashboardCard(
                    title: 'Assignments Due',
                    content: 'No assigments due',
                    onTap: _openAssignments,
                  ),
                  /*
                  DashboardCard(
                    title: 'Notifications',
                    content: 'New grades posted, Parent meeting on Friday',
                    onTap: _openNotifications,
                  ),
                  */ // Notification Dash-Card
                  DashboardCard(
                    title: 'Events',
                    content: 'No events scheduled',
                    onTap: _openEvents,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(0xFF026A75), width: 2),
        ),
        color: Color(0xFFCFE3DD),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF026a75),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Assignments'),
      backgroundColor: Color(0xFFCFE3DD),
      body: const Center(
          child: Text(
              'No Assignments Due...',
            style: TextStyle(
              color: Color(0xFF026A75),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
  }
}

/*
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Page')),
    );
  }
}
*/ // Notification Page
import 'package:flutter/material.dart';
import 'customAppBar.dart';
import 'navigation_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _selectedSemester = 'Semester 1'; // Default semester
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6'];

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/AttendancePage');
  }

  final Map<String, Map<String, dynamic>> _attendanceData = {
    'Subject 1': {
      'percentage': 85,
      'total': '85/100',
      'dates': [
        {'date': '2024-03-01', 'status': 'Present'},
      ],
    },
    'Subject 2': {
      'percentage': 90,
      'total': '90/100',
      'dates': [
        {'date': '2024-03-01', 'status': 'Present'},
      ],
    },
    'Subject 3': {
      'percentage': 88,
      'total': '88/100',
      'dates': [
        {'date': '2024-03-01', 'status': 'Present'},
      ],
    },
    'Subject 4': {
      'percentage': 75,
      'total': '75/100',
      'dates': [
        {'date': '2024-03-01', 'status': 'Absent'},
      ],
    },
  };

  void _navigateToSubjectDetails(String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectAttendanceDetailsPage(
          subject: subject,
          details: _attendanceData[subject]!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Attendance',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedSemester,
              items: _semesters.map((String semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSemester = newValue;
                    // TODO: Fetch attendance and subject data based on selected semester
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Overall Attendance: 88%', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Attendance: 88/100', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ..._attendanceData.keys.map((subject) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text(subject),
                trailing: Text('${_attendanceData[subject]!['percentage']}%'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey[200],
                onTap: () => _navigateToSubjectDetails(subject),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class SubjectAttendanceDetailsPage extends StatelessWidget {
  final String subject;
  final Map<String, dynamic> details;

  const SubjectAttendanceDetailsPage({
    super.key,
    required this.subject,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Attendance',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Overall: ${details['percentage']}%',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Total: ${details['total']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...(details['dates'] as List<Map<String, String>>).map(
                  (date) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${date['date']}: ${date['status']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
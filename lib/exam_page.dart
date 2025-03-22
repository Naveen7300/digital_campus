
import 'package:flutter/material.dart';
import 'navigation_service.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  String _selectedSemester = 'Semester 1';
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6'];

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/ExamPage');
    //WidgetsBinding.instance.addObserver(this);
  }

  final Map<String, dynamic> _examData = {
    'Internals': {
      'date': '2024-03-15',
      'timetable': [
        {'subject': 'Math', 'time': '10:00 AM'},
        {'subject': 'Science', 'time': '11:30 AM'},
      ],
      'marks': {'Math': 85, 'Science': 90},
    },
    'Preparatory': {
      'date': '2024-04-10',
      'timetable': [
        {'subject': 'English', 'time': '10:00 AM'},
        {'subject': 'History', 'time': '11:30 AM'},
      ],
      'marks': null, // Results pending
    },
    'Final': {
      'date': null, // Dates not declared
      'timetable': null,
      'marks': null,
    },
  };

  void _navigateToExamDetails(String exam) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamDetailsPage(exam: exam, details: _examData[exam]),
      ),
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
              'Exams',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff026A75),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('Exams:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._examData.keys.map((exam) {
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(exam),
                  onTap: () => _navigateToExamDetails(exam),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ExamDetailsPage extends StatelessWidget {
  final String exam;
  final Map<String, dynamic> details;

  const ExamDetailsPage({super.key, required this.exam, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exam)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (details['date'] == null)
              const Text('Dates yet to be declared.')
            else if (details['timetable'] != null)
              ...((details['timetable'] as List<Map<String, String>>).map((item) {
                return Text('${item['subject']}: ${item['time']}');
              }).toList())
            else if (details['marks'] == null)
                const Text('Results yet to be declared.')
              else
                ...((details['marks'] as Map<String, int>).entries.map((entry) {
                  return Text('${entry.key}: ${entry.value}');
                }).toList()),
          ],
        ),
      ),
    );
  }
}

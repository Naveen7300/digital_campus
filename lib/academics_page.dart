import 'package:flutter/material.dart';
import 'customAppBar.dart';
import 'navigation_service.dart';

class AcademicsPage extends StatefulWidget {
  const AcademicsPage({super.key});

  @override
  _AcademicsPageState createState() => _AcademicsPageState();
}

class _AcademicsPageState extends State<AcademicsPage> {
  String _selectedSemester = 'Semester 1';
  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6'
  ];

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/AcademicsPage');
  }

  final Map<String, Map<String, dynamic>> _subjectData = {
    'Subject 1': {
      'subCode': 'SubCode 1',
      'courseMaterials': [
        {'name': 'Lecture 1.pdf', 'url': 'path/to/lecture1.pdf'},
        {'name': 'Lab Manual.docx', 'url': 'path/to/lab_manual.docx'},
      ],
      'assignments': [
        {'name': 'Activity 1', 'description': 'Do the activity', 'supportingDoc': 'path/to/activity1.pdf'},
        {'name': 'Activity 2', 'description': 'Do the activity', 'supportingDoc': null},
      ],
    },
    'Subject 2': {
      'subCode': 'SubCode 2',
      'courseMaterials': [
        {'name': 'Chapter 1.ppt', 'url': 'path/to/chapter1.ppt'},
      ],
      'assignments': [
        {'name': 'Project Proposal', 'description': 'Submit your proposal', 'supportingDoc': null},
      ],
    },
  };

  String? _selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Academics',
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
                    // TODO: Fetch subject data based on selected semester
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Subjects:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._subjectData.entries.map((entry) {
              final subjectName = entry.key;
              final subjectDetails = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(subjectName),
                    subtitle: Text(subjectDetails['subCode']),
                    onTap: () {
                      setState(() {
                        if (_selectedSubject == subjectName) {
                          _selectedSubject = null;
                        } else {
                          _selectedSubject = subjectName;
                        }
                      });
                    },
                  ),
                  if (_selectedSubject == subjectName)
                    SubjectDetails(
                      subjectDetails: subjectDetails,
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class SubjectDetails extends StatefulWidget {
  final Map<String, dynamic> subjectDetails;

  const SubjectDetails({super.key, required this.subjectDetails});

  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Course Material'),
              Tab(text: 'Assignments'),
            ],
          ),
          SizedBox(
            height: 200, // Adjust height as needed
            child: TabBarView(
              controller: _tabController,
              children: [
                CourseMaterialTab(courseMaterials: widget.subjectDetails['courseMaterials']),
                AssignmentsTab(assignments: widget.subjectDetails['assignments']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseMaterialTab extends StatelessWidget {
  final List<Map<String, String>> courseMaterials;

  const CourseMaterialTab({super.key, required this.courseMaterials});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courseMaterials.length,
      itemBuilder: (context, index) {
        final material = courseMaterials[index];
        return ListTile(
          title: Text(material['name']!),
          onTap: () {
            // TODO: Open the course material file (e.g., using url_launcher)
          },
        );
      },
    );
  }
}

class AssignmentsTab extends StatelessWidget {
  final List<Map<String, dynamic>> assignments;

  const AssignmentsTab({super.key, required this.assignments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return ListTile(
          title: Text(assignment['name']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentDetailsPage(assignment: assignment),
              ),
            );
          },
        );
      },
    );
  }
}

class AssignmentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> assignment;

  const AssignmentDetailsPage({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(assignment['name']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${assignment['description']!}'),
            if (assignment['supportingDoc'] != null)
              ElevatedButton(
                onPressed: () {
                  // TODO: Open the supporting document (e.g., using url_launcher)
                },
                child: const Text('View Supporting Document'),
              ),
            ElevatedButton(
                onPressed: () {
                  // TODO: Implement file upload functionality
                },
                child: const Text(
                    'Upload File'
                )
            ),
          ],
        ),
      ),
    );
  }
}
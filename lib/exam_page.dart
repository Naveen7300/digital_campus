import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';

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
      'timetable': [
        {'subject': 'Android Development', 'date': '15-01-2025', 'time': '10:00 AM'},
        {'subject': 'Cloud Development', 'date': '15-01-2025', 'time': '11:30 AM'},
        {'subject': 'Python Programming', 'date': '16-01-2025', 'time': '10:00 AM'},
      ],
      'marks': {'Android Development': 90, 'Cloud Development': 85, 'Python Programming': 85},
    },
    'Preparatory': {
      'timetable': [
        {'subject': 'Android Development', 'date': '10-03-2025', 'time': '10:00 AM'},
        {'subject': 'Cloud Development', 'date': '10-03-2025', 'time': '11:30 AM'},
        {'subject': 'Python Programming', 'date': '11-03-2025', 'time': '10:00 AM'},
      ],
      'marks': null, // Results pending
    },
    'Final': {
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
            Expanded(
              child: Column(
                children: [
                  CustomDropdown(
                    items: _semesters,
                    initialValue: _selectedSemester,
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedSemester = newValue;
                        // TODO: Fetch attendance and subject data based on selected semester
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                        'Exams:',
                        style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF026A75),
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._examData.keys.map((exam) {
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          exam,
                          style: TextStyle(
                            color: Color(0xFFCFE3DD),
                            fontSize: 16,
                          ),
                        ),
                        onTap: () => _navigateToExamDetails(exam),
                        tileColor: Color(0xFF026A75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ]
              )
            )
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
    print('Received exam details: $details');
    return Scaffold(
      appBar: CustomAppBar(title: exam),
      backgroundColor: Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (details['timetable'] == null || details['timetable'].isEmpty) ...[
              const Center(
                  child: Text(
                    'Dates yet to be declared...',
                    style: TextStyle(
                      color: Color(0xFF026A75),
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    )
                  )
              )
            ]
            else if (details['timetable'] != null && details['marks'] == null) ...[
              _buildTimetableDisplay(details['timetable']),
              const SizedBox(height: 15),
              const Divider(color: Colors.grey),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'Results yet to be declared...',
                  style: TextStyle(
                    color: Color(0xFF026A75),
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ]
            else if (details['timetable'] != null && details['marks'] != null) ...[
              _buildTimetableDisplay(details['timetable']),
                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),
              _buildMarksDisplay(details['marks']),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableDisplay(List<dynamic> timetable) {
    Map<String, List<Map<String, String>>> dateWiseSubjects = {};

    for (var item in timetable) {
      String date = item['date'];
      String subject = item['subject'];
      String time = item['time'];

      if (!dateWiseSubjects.containsKey(date)) {
        dateWiseSubjects[date] = [];
      }
      dateWiseSubjects[date]!.add({'subject': subject, 'time': time});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dateWiseSubjects.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(color: Color(0xFF026A75), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ...entry.value.map((subjectDetails) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                    '${subjectDetails['subject']} (${subjectDetails['time']})',
                  style: TextStyle(
                    color: Color(0xFF026A75),
                    fontSize: 16
                  )
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMarksDisplay(Map<String, dynamic> marks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Marks:',
          style: TextStyle(color: Color(0xFF026A75),fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ...marks.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${entry.key}: ${entry.value}',
              style: TextStyle(
                color: Color(0xFF026A75),
                fontSize: 16
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _selectedValue;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  // Create overlay dropdown menu
  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 4,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCFE3DD),
              border: Border.all(color: const Color(0xFF026A75)),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((item) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedValue = item;
                      _removeOverlay();
                    });
                    widget.onChanged(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF026A75),
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Show dropdown
  void _showOverlay() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Close dropdown
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: const Color(0xFF026A75), width: 2)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFCFE3DD),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedValue,
              style: const TextStyle(
                  color: Color(0xFF026A75),
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF026A75)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}
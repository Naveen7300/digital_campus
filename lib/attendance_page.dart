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
      backgroundColor: Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff026A75),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            const Text('Overall Attendance: 88%', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Attendance: 88/100', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ..._attendanceData.keys.map((subject) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Text(
                    subject,
                  style: TextStyle(
                    color: Color(0xFFCFE3DD)
                  ),
                ),
                trailing: Text(
                    '${_attendanceData[subject]!['percentage']}%',
                    style: TextStyle(
                      color: Color(0xFFCFE3DD),
                      fontSize: 14
                    )
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Color(0xFF026A75),
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
      appBar: CustomAppBar(
        title: 'Attendance',
      ),
      backgroundColor: Color(0xffCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF026A75)
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Overall: ${details['percentage']}%',
              style: const TextStyle(fontSize: 18, color: Color(0xFF026A75)),
            ),
            Text(
              'Total: ${details['total']}',
              style: const TextStyle(fontSize: 18, color: Color(0xFF026A75)),
            ),
            const SizedBox(height: 15),
            const Text(
              'Dates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF026A75)),
            ),
            ...(details['dates'] as List<Map<String, String>>).map(
                  (date) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFE3DD),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date['date']!,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF026A75)),
                      ),
                      Text(
                        date['status']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: date['status'] == 'Present' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
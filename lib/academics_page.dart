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
      backgroundColor: Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academics',
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
            const SizedBox(height: 18),
            const Text('Subjects :', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF026A75))),
            const SizedBox(height: 8),
            ..._subjectData.entries.map((entry) {
              final subjectName = entry.key;
              final subjectDetails = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                          subjectName,
                        style: TextStyle(
                          color: Color(0xFFCFE3DD),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                          subjectDetails['subCode'],
                        style: TextStyle(
                            color: Color(0xFFA4DCCB),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (_selectedSubject == subjectName) {
                            _selectedSubject = null;
                          } else {
                            _selectedSubject = subjectName;
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                        tileColor: Color(0xFF026A75),
                    ),
                    if (_selectedSubject == subjectName)
                      SubjectDetails(
                        subjectDetails: subjectDetails,
                      ),
                  ],
                )
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
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            color: Color(0xFFCFE3DD),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF026A75),
              labelColor: const Color(0xFF026A75),
              unselectedLabelColor: const Color(0xFF026A75),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),
              tabs: const [
                Tab(text: 'Course Material'),
                Tab(text: 'Assignments'),
              ],
            ),
          ),
          SizedBox(
            height: 200, // Adjust height as needed
            child: Container(
              color: Color(0xFFCFE3DD),
              child: TabBarView(
              controller: _tabController,
              children: [
                CourseMaterialTab(courseMaterials: widget.subjectDetails['courseMaterials']),
                AssignmentsTab(assignments: widget.subjectDetails['assignments']),
              ],
            ),)
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
          title: Text(
              material['name']!,
            style: TextStyle(
              color: Color(0xFF026A75),
              fontWeight: FontWeight.normal,
            ),
          ),
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
          title: Text(
            assignment['name']!,
            style: TextStyle(
              color: Color(0xFF026A75),
              fontWeight: FontWeight.normal,
            ),),
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
      backgroundColor: const Color(0xFFCFE3DD),
      appBar: CustomAppBar(title: assignment['name']!),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: const TextStyle(
                        color: Color(0xFF026A75),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Dear Students, you can submit your Activity 1 by using this link.',
                    style: TextStyle(color: Color(0xFF026A75), fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // The draggable drawer stays on top
          BottomDrawer(),
        ],
      ),
    );
  }
}

class BottomDrawer extends StatefulWidget {
  const BottomDrawer({super.key});

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final DraggableScrollableController _controller = DraggableScrollableController();
  bool isFullyOpen = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isFullyOpen = _controller.size == 0.8;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.24,
      minChildSize: 0.24,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFCFE3DD),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController, // Enable drag scrolling
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if(_controller.size < 0.5) {
                    _controller.animateTo(
                      0.8,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                  else {
                    _controller.animateTo(
                      0.24,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Container(
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.grey,
                    size: 45,
                  ),
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Your work',
                    style: TextStyle(
                        color: Color(0xFF026A75),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'No due date',
                    style: TextStyle(color: Color(0xFF026A75), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (!isFullyOpen) ...[
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026A75),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '+ Add Work',
                    style: TextStyle(color: Color(0xFFCFE3DD), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
              if (isFullyOpen) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attachments',
                    style: TextStyle(
                        color: Color(0xFF026A75),
                        fontSize: 22,
                    )
                  )
                ),
                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFE3DD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                    children: [
                      Center(
                        child: Text(
                          'You have no Attachments uploaded',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14
                          )
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026A75),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '+ Add Work',
                    style: TextStyle(color: Color(0xFFCFE3DD), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFCFE3DD),
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(color: const Color(0xFF026A75), style: BorderStyle.solid, width: 2.5),
                  ),
                  child: const Text(
                    'Mark as Done',
                    style: TextStyle(color: Color(0xFF026A75), fontSize: 16),
                  ),
                ),
              ]
            ],
          ),
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
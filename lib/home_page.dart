import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'dart:async';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/HomePage');
    WidgetsBinding.instance.addObserver(this);
  }

  void _openTimetable() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimetablePage()),
    );
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
                    content: 'Math, Science, History',
                    onTap: _openTimetable,
                  ),
                  DashboardCard(
                    title: 'Assignments Due',
                    content: 'Math Homework, Science Project',
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
                    content: 'School Fair on Saturday',
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
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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

// Placeholder pages for navigation
class TimetablePage extends StatefulWidget {
  final String pdfPath;
  const TimetablePage({Key? key, this.pdfPath = 'assets/Class_TT.pdf'})
      : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.pdfPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            backgroundColor: Colors.grey,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(
                  error.toString()); // Keep the print for debugging
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = 'Page $page: ${error.toString()}';
              });
              print('$page: ${error.toString()}'); // Keep the print
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int? page, int? total) {
              if (page != null && total != null) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              }
            },
          ),
          if (!isReady && errorMessage.isEmpty)
            const Center(child: CircularProgressIndicator()),
          if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage)),
        ],
      ),
    );
  }
}

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: const Center(child: Text('Assignments Page')),
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

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const Center(child: Text('Events Page')),
    );
  }
}
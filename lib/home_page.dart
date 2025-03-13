import 'package:flutter/material.dart';
import 'navigation_service.dart';

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

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsPage()),
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
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
                  DashboardCard(
                    title: 'Notifications',
                    content: 'New grades posted, Parent meeting on Friday',
                    onTap: _openNotifications,
                  ),
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
class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: const Center(child: Text('Timetable Page')),
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
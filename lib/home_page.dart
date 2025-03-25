import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
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
                    content: 'iOS, MAT',
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
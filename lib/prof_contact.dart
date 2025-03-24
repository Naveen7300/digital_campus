import 'package:flutter/material.dart';
import 'customAppBar.dart';
import 'navigation_service.dart';

class ProfContactPage extends StatefulWidget {
  const ProfContactPage({super.key});

  @override
  _ProfContactPageState createState() => _ProfContactPageState();
}

class _ProfContactPageState extends State<ProfContactPage> {

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/ProfContactPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Contacts'),
      backgroundColor: Color(0xFFCFE3DD),
      body: const Center(
          child: Text(
            'No Contacts available...',
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
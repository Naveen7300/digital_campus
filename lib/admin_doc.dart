import 'package:flutter/material.dart';
import 'customAppBar.dart';
import 'navigation_service.dart';

class AdminDocPage extends StatefulWidget {
  const AdminDocPage({super.key});

  @override
  _AdminDocPageState createState() => _AdminDocPageState();
}

class _AdminDocPageState extends State<AdminDocPage> {

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/AdminDocPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Documents'),
      backgroundColor: Color(0xFFCFE3DD),
      body: const Center(
          child: Text(
            'No Documents available...',
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
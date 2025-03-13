import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/ProfilePage');
    //WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
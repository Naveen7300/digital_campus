import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'customAppBar.dart';
import 'navigation_service.dart';

class ProfContactPage extends StatefulWidget {
  const ProfContactPage({super.key});

  @override
  _ProfContactPageState createState() => _ProfContactPageState();
}

class _ProfContactPageState extends State<ProfContactPage> {
  // Sample professor data (replace with your actual data)
  final List<Map<String, String>> _professors = [
    {
      'name': 'Dr. K. Suneetha',
      'contact': '8473689840',
      'email': 'k.suneetha@jainuniversity.ac.in',
    },
    {
      'name': 'Dr. Sanjeev Kumar Mandal',
      'contact': '9876543210',
      'email': 'sanjeev@jainuniversity.ac.in',
    },
    {
      'name': 'Dr. Taskeen Zaidi',
      'contact': '9876543211',
      'email': 'taskeen@jainuniversity.ac.in',
    },
    {
      'name': 'Dr. Ramkumar Krishnamoorthy',
      'contact': '9876543212',
      'email': 'ramkumar@jainuniversity.ac.in',
    },
    {
      'name': 'Mr. Diwakara Vansuman',
      'contact': '9876543213',
      'email': 'diwakara@jainuniversity.ac.in',
    },
    {
      'name': 'Ms. Pratima',
      'contact': '9876543214',
      'email': 'prathima@jainuniversity.ac.in',
    },
  ];

  String? _selectedProfessor;

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/ProfContactPage');
  }

  // Function to launch phone call
  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Prof. Contact'),
      backgroundColor: const Color(0xFFCFE3DD),
      body: ListView.builder(
        itemCount: _professors.length,
        itemBuilder: (context, index) {
          final professor = _professors[index];
          final isSelected = _selectedProfessor == professor['name'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child:ListTile(
                  title: Text(
                    professor['name']!,
                    style: const TextStyle(
                      color: Color(0xFF026A75),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedProfessor = isSelected ? null : professor['name'];
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xff016a75)),
                  ),
                  tileColor: const Color(0xFFCFE3DD),
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.grey,),
                      const SizedBox(height: 8),
                      Text(
                        'Contact: ${professor['contact']!}',
                        style: const TextStyle(color: Color(0xff026a75), fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Email: ${professor['email']!}',
                        style: const TextStyle(color: Color(0xff026a75), fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _launchPhoneCall(professor['contact']!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF026A75),
                          foregroundColor: const Color(0xFFCFE3DD),
                        ),
                        child: const Text('Call'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
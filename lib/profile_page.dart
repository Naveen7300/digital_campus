import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> studentData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/ProfilePage');
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final email = user.email;
      final databaseRef = FirebaseDatabase.instance.ref('Students');

      final snapshot = await databaseRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        bool found = false;

        // Loop through student records
        data.forEach((key, student) {
          if (student['collegeMail'] == email || student['personalMail'] == email) {
            setState(() {
              studentData = Map<String, dynamic>.from(student);
              _isLoading = false;
            });
            found = true;
          }
        });

        if (!found) {
          print('No matching student found');
          setState(() => _isLoading = false);
        }
      } else {
        print('No data found in Firebase');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching student data: $e');
      setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: studentData['profilePhoto'] != null
                        ? AssetImage(studentData['profilePhoto'])
                        : null,
                    backgroundColor: Colors.grey[300],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Name', studentData['name'] ?? 'N/A'),
            _buildInfoRow('USN', studentData['usn'] ?? 'N/A'),
            _buildInfoRow('ABC ID', studentData['abcId'] ?? 'N/A'),
            _buildInfoRow('Course', studentData['course'] ?? 'N/A'),
            _buildInfoRow(
                'Specialization', studentData['specialization'] ?? 'N/A'),
            _buildInfoRow('Batch', studentData['batch'] ?? 'N/A'),
            _buildInfoRow(
                'Date of Birth', studentData['dateOfBirth'] ?? 'N/A'),
            _buildInfoRow('Gender', studentData['gender'] ?? 'N/A'),
            _buildInfoRow(
                'College Mail', studentData['collegeMail'] ?? 'N/A'),
            _buildInfoRow(
                'Personal Mail', studentData['personalMail'] ?? 'N/A'),
            _buildInfoRow(
                'Mobile Number', studentData['mobileNumber'] ?? 'N/A'),
            _buildInfoRow('Address', studentData['address'] ?? 'N/A'),
            const SizedBox(height: 20),
            const Text('Parent Details',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoRow(
                'Father\'s Name', studentData['fatherName'] ?? 'N/A'),
            _buildInfoRow('Father\'s Contact',
                studentData['fatherContact'] ?? 'N/A'),
            _buildInfoRow(
                'Father\'s Email', studentData['fatherEmail'] ?? 'N/A'),
            _buildInfoRow(
                'Mother\'s Name', studentData['motherName'] ?? 'N/A'),
            _buildInfoRow('Mother\'s Contact',
                studentData['motherContact'] ?? 'N/A'),
            _buildInfoRow(
                'Mother\'s Email', studentData['motherEmail'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }
}
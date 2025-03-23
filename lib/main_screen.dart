import 'package:flutter/material.dart';
import 'home_page.dart';
import 'attendance_page.dart';
import 'academics_page.dart';
import 'exam_page.dart';
import 'chats_page.dart';
import 'package:flutter/services.dart';
import 'customAppBar.dart';
import 'profile_page.dart';
import 'events_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationHistory = [];
  bool _isSnackBarVisible = false;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AttendancePage(),
    AcademicsPage(),
    ExamPage(),
    ChatsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _navigationHistory.add(_selectedIndex);
      _selectedIndex = index;
      _isSnackBarVisible = false;
    });
  }

  void _handleBackButton() {
    if (_navigationHistory.isNotEmpty) {
      setState(() {
        _selectedIndex = 0;
        _navigationHistory.clear();
        _isSnackBarVisible = false;
      });
    } else {
      if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
          _isSnackBarVisible = false;
        });
      } else {
        if (!_isSnackBarVisible) {
          final snackBar = SnackBar(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Double Tap to quit"),
              ],
            ),
            duration: const Duration(milliseconds: 700),
            onVisible: () {
              setState(() {
                _isSnackBarVisible = true;
              });
            },
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
            setState(() {
              _isSnackBarVisible = false;
            });
          });
        }
      }
    }
  }

  void _showQuitDialog() {
    setState(() {
      _isSnackBarVisible = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quit App?"),
          content: const Text("Do you want to exit the application?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Quit"),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Digital Campus',
        onMenuPressed: () {
          Builder(
            builder: (BuildContext context) {
              showMenu(context);
              return const SizedBox.shrink(); // Builder needs to return a widget
            },
          );
        },
        onBackDoubleTap: _showQuitDialog,
        onBackSingleTap: _handleBackButton,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff026A75),
        unselectedItemColor: const Color(0xFFCFE3DD),
        onTap: _onItemTapped,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xff026A75),
              ),
              child: Text('Menu'), //TODO: Create new menu Drawerheader to display user image, name, ID, etc.
            ),
            ListTile(
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Prof. Contact'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Admin Doc.'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            /*ListTile(
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About US'),
              onTap: () {
                Navigator.pop(context);
              },
            ),*/
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  void showMenu(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }
}
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'navigation_service.dart';
import 'customAppBar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with WidgetsBindingObserver {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Add the event for 28/03/2025
  Map<DateTime, List<String>> _events = {
    DateTime.utc(2025, 3, 28): ['Final Semester Project Report Submission'],
  };

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/EventsPage');
    WidgetsBinding.instance.addObserver(this);
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Calender'),
      backgroundColor: const Color(0xFFCFE3DD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                print('Selected Day: $selectedDay');
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerStyle: HeaderStyle(
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                formatButtonDecoration: BoxDecoration(
                  color: Color(0xFF026A75),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                titleTextFormatter: (date, locale) {
                  return "${DateFormat.MMMM(locale).format(date)} ${date.year}";
                },
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF026a75),
                  fontSize: 20.0,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
                  if (isSameDay(day, _selectedDay)) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF027A75),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(color: Color(0xFFCFE3DD)),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: day.weekday == DateTime.sunday ? Colors.red.shade800 : const Color(0xFF026A75),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF027A75),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFFCFE3DD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF68a7a9),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFFCFE3DD),
                      ),
                    ),
                  );
                },
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 7,
                      child: Container(
                        height: 8.0,
                        width: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              eventLoader: _getEventsForDay, // Add eventLoader here
            ),
            const SizedBox(height: 20),
            Text(
              "Events for ${_selectedDay.toString().split(' ')[0]}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF026A75),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey,),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _getEventsForDay(_selectedDay)
                    .map((event) => Container( // Wrap ListTile in Container
                  decoration: BoxDecoration(
                    color: Color(0xffcfe3dd), // Add background color
                    borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4.0), // Add margin for spacing
                  child: ListTile(
                    title: Text(
                      event,
                      style: TextStyle(
                        color: Color(0xff026a75),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
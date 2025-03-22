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

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/EventsPage');
    WidgetsBinding.instance.addObserver(this);
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
                // Use a builder that returns a Widget for each day.
                defaultBuilder : (BuildContext context, DateTime day, DateTime focusedDay) {
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
                          fontWeight: FontWeight.bold
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
                      bottom: 1,
                      child: Container(
                        height: 8.0,
                        width: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(
                "Events for ${_selectedDay.toString().split(' ')[0]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF026A75),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
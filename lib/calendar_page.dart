import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'db_helper.dart';
import 'add_reminder_page.dart'; // Import the AddReminderPage

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Map<String, dynamic>>> _reminders;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _reminders = {};
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminders = await DBHelper.fetchReminders();
    setState(() {
      _reminders.clear();
      for (var reminder in reminders) {
        DateTime date = DateTime.parse(reminder['date']);
        if (_reminders[date] == null) {
          _reminders[date] = [];
        }
        _reminders[date]?.add(reminder);
      }
    });
  }

  Widget _buildReminderList() {
    final selectedReminders = _reminders[_selectedDate] ?? [];
    if (selectedReminders.isEmpty) {
      return const Center(child: Text('No reminders for this date.'));
    }

    return ListView.builder(
      itemCount: selectedReminders.length,
      itemBuilder: (context, index) {
        final reminder = selectedReminders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Time: ${reminder['time']}'),
                Text('Location: ${reminder['location']}'),
                Text('Description: ${reminder['description']}'),
                Text('Notes: ${reminder['notes']}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Redirect to AddReminderPage with existing reminder details for editing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReminderPage(
                          selectedDate: _selectedDate,
                          reminder: reminder, // Pass the existing reminder data
                        ),
                      ),
                    ).then((_) {
                      // Reload reminders after editing
                      _loadReminders();
                    });
                  },
                  child: const Text('Edit Reminder'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    // Delete reminder
                    await DBHelper.deleteReminder(reminder['id']);
                    _loadReminders(); // Reload reminders after deletion
                  },
                  child: const Text('Delete Reminder'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (day, events) {
              setState(() {
                _selectedDate = day;
              });
            },
            eventLoader: (day) {
              return _reminders[day] ?? [];
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // Hide format button
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildReminderList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Redirect to AddReminderPage to add a new reminder
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminderPage(
                selectedDate: _selectedDate,
                reminder: {}, // Pass an empty map for a new reminder
              ),
            ),
          ).then((_) {
            // Reload reminders after adding a new one
            _loadReminders();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddReminderPage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic> reminder;

  const AddReminderPage({
    Key? key,
    required this.selectedDate,
    required this.reminder,
  }) : super(key: key);

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder['title']);
    _timeController = TextEditingController(text: widget.reminder['time']);
    _locationController =
        TextEditingController(text: widget.reminder['location']);
    _descriptionController =
        TextEditingController(text: widget.reminder['description']);
    _notesController = TextEditingController(text: widget.reminder['notes']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveReminder() async {
    final reminder = {
      'id': widget.reminder['id'] ?? null, // Handle null for new reminders
      'title': _titleController.text,
      'date': widget.selectedDate.toIso8601String(),
      'time': _timeController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'notes': _notesController.text,
    };

    if (widget.reminder['id'] == null) {
      await DBHelper.insertReminder(reminder); // Insert new reminder
    } else {
      await DBHelper.updateReminder(reminder); // Update existing reminder
    }

    Navigator.pop(context); // Return to calendar page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveReminder,
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

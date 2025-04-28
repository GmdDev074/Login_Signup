import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_view_controller.dart';
import '../models/alarm_model.dart';
import '../models/note_model.dart';

class CreateItemBottomSheet extends StatefulWidget {
  final String userId;
  final Note? note;
  final Alarm? alarm;

  const CreateItemBottomSheet({
    super.key,
    required this.userId,
    this.note,
    this.alarm,
  });

  @override
  State<CreateItemBottomSheet> createState() => _CreateItemBottomSheetState();
}

class _CreateItemBottomSheetState extends State<CreateItemBottomSheet> {
  final HomeViewController _controller = HomeViewController();
  final _noteTitleController = TextEditingController();
  final _noteDescriptionController = TextEditingController();
  final _alarmNameController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _noteTitleController.text = widget.note!.title;
      _noteDescriptionController.text = widget.note!.description;
    }
    if (widget.alarm != null) {
      _alarmNameController.text = widget.alarm!.name;
      _selectedDateTime = widget.alarm!.scheduledTime;
    }
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteDescriptionController.dispose();
    _alarmNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: DefaultTabController(
        length: 2,
        initialIndex: widget.alarm != null ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Note'),
                Tab(text: 'Alarm'),
              ],
              labelColor: Colors.green.shade700,
              unselectedLabelColor: Colors.grey,
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  _buildNoteForm(context),
                  _buildAlarmForm(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _noteTitleController,
          decoration: const InputDecoration(
            labelText: 'Note Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _noteDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
              onPressed: () async {
                if (_noteTitleController.text.isNotEmpty) {
                  final note = Note(
                    id: widget.note?.id,
                    title: _noteTitleController.text,
                    description: _noteDescriptionController.text,
                    userId: widget.userId,
                    createdAt: widget.note?.createdAt ?? DateTime.now(),
                  );
                  try {
                    if (widget.note == null) {
                      await _controller.createNote(note);
                    } else {
                      await _controller.updateNote(note);
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save note: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                }
              },
              child: Text(widget.note == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlarmForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _alarmNameController,
          decoration: const InputDecoration(
            labelText: 'Alarm Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDateTime ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedDateTime != null
                    ? TimeOfDay.fromDateTime(_selectedDateTime!)
                    : TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: Text(
            _selectedDateTime == null
                ? 'Select Date & Time'
                : DateFormat('MMM dd, yyyy HH:mm').format(_selectedDateTime!),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
              onPressed: () async {
                if (_alarmNameController.text.isNotEmpty && _selectedDateTime != null) {
                  final alarm = Alarm(
                    id: widget.alarm?.id,
                    name: _alarmNameController.text,
                    scheduledTime: _selectedDateTime!,
                    userId: widget.userId,
                  );
                  try {
                    if (widget.alarm == null) {
                      await _controller.createAlarm(alarm);
                    } else {
                      await _controller.updateAlarm(alarm);
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to schedule alarm: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name and Date/Time are required')),
                  );
                }
              },
              child: Text(widget.alarm == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ],
    );
  }
}
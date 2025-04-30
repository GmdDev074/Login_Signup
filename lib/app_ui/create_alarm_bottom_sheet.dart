import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/alarm_controller.dart';
import '../models/alarm_model.dart';

class CreateAlarmBottomSheet extends StatefulWidget {
  final String userId;
  final Alarm? alarm;

  const CreateAlarmBottomSheet({super.key, required this.userId, this.alarm});

  @override
  State<CreateAlarmBottomSheet> createState() => _CreateAlarmBottomSheetState();
}

class _CreateAlarmBottomSheetState extends State<CreateAlarmBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _controller = AlarmController();
  DateTime? _selectedDateTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _nameController.text = widget.alarm!.name;
      _selectedDateTime = widget.alarm!.scheduledTime;
    } else {
      _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime!),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveAlarm() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final alarm = Alarm(
          id: widget.alarm?.id,
          userId: widget.userId,
          name: _nameController.text,
          scheduledTime: _selectedDateTime!,
        );
        if (widget.alarm == null) {
          await _controller.createAlarm(alarm);
        } else {
          await _controller.updateAlarm(alarm);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.alarm == null ? 'Create Alarm' : 'Update Alarm',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Alarm Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an alarm name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDateTime != null
                    ? 'Scheduled: ${DateFormat('MMM dd, yyyy hh:mm a').format(_selectedDateTime!)}'
                    : 'Select Date & Time',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _saveAlarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.alarm == null ? 'Create' : 'Update'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_view_controller.dart';
import '../models/schedule_model.dart';

class AddScheduleBottomSheet extends StatefulWidget {
  final String userId;
  final String subjectId;
  final String subjectName;

  const AddScheduleBottomSheet({
    super.key,
    required this.userId,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<AddScheduleBottomSheet> createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDateTime;
  final _roomController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _topicController = TextEditingController();
  final _schoolClassController = TextEditingController();
  final _universityDepartmentController = TextEditingController();
  final _universitySemesterController = TextEditingController();
  final HomeViewController _controller = HomeViewController();

  String _institutionType = 'School'; // Default institution type
  String? _collegeField; // For college field selection

  final _dateFocusNode = FocusNode();
  final _timeFocusNode = FocusNode();
  final _roomFocusNode = FocusNode();
  final _lecturerFocusNode = FocusNode();
  final _topicFocusNode = FocusNode();
  final _schoolClassFocusNode = FocusNode();
  final _collegeFieldFocusNode = FocusNode();
  final _universityDepartmentFocusNode = FocusNode();
  final _universitySemesterFocusNode = FocusNode();

  // List of college fields
  final List<String> _collegeFields = ['FA', 'ICS', 'FSc (Pre-Medical)', 'FSc ( Pre-Engineering)', 'I.Com', 'DAE (Electrical)', 'DAE (Mechanical)', 'DAE (Civil)', 'DAE (Electronics)'];

  @override
  void dispose() {
    _roomController.dispose();
    _lecturerController.dispose();
    _topicController.dispose();
    _schoolClassController.dispose();
    _universityDepartmentController.dispose();
    _universitySemesterController.dispose();
    _dateFocusNode.dispose();
    _timeFocusNode.dispose();
    _roomFocusNode.dispose();
    _lecturerFocusNode.dispose();
    _topicFocusNode.dispose();
    _schoolClassFocusNode.dispose();
    _collegeFieldFocusNode.dispose();
    _universityDepartmentFocusNode.dispose();
    _universitySemesterFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime?.hour ?? 0,
          _selectedDateTime?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = _selectedDateTime ?? DateTime.now();
        _selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      final schedule = Schedule(
        scheduledDateTime: _selectedDateTime!,
        room: _roomController.text,
        lecturer: _lecturerController.text,
        topic: _topicController.text,
        subjectId: widget.subjectId,
        userId: widget.userId,
        institutionType: _institutionType,
        schoolClass: _institutionType == 'School' ? _schoolClassController.text : null,
        collegeField: _institutionType == 'College' ? _collegeField : null,
        universityDepartment: _institutionType == 'University' ? _universityDepartmentController.text : null,
        universitySemester: _institutionType == 'University' ? _universitySemesterController.text : null,
      );
      try {
        await _controller.addSchedule(schedule);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add schedule: $e')),
        );
      }
    } else if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule Lecture for: ${widget.subjectName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Institution Type Dropdown
              DropdownButtonFormField<String>(
                value: _institutionType,
                decoration: const InputDecoration(
                  labelText: 'Institution Type',
                  border: OutlineInputBorder(),
                ),
                items: ['School', 'College', 'University'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _institutionType = value!;
                    // Reset fields when institution type changes
                    _schoolClassController.clear();
                    _collegeField = null;
                    _universityDepartmentController.clear();
                    _universitySemesterController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              // Conditional Fields based on Institution Type
              if (_institutionType == 'School') ...[
                TextFormField(
                  focusNode: _schoolClassFocusNode,
                  controller: _schoolClassController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Class (e.g., Class 10)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the class';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_dateFocusNode);
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_institutionType == 'College') ...[
                DropdownButtonFormField<String>(
                  focusNode: _collegeFieldFocusNode,
                  value: _collegeField,
                  decoration: const InputDecoration(
                    labelText: 'Field',
                    border: OutlineInputBorder(),
                  ),
                  items: _collegeFields.map((String field) {
                    return DropdownMenuItem<String>(
                      value: field,
                      child: Text(field),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _collegeField = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a field';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_institutionType == 'University') ...[
                TextFormField(
                  focusNode: _universityDepartmentFocusNode,
                  controller: _universityDepartmentController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Department (e.g., Computer Science)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the department';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_universitySemesterFocusNode);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  focusNode: _universitySemesterFocusNode,
                  controller: _universitySemesterController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Semester (e.g., Semester 3)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the semester';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_dateFocusNode);
                  },
                ),
                const SizedBox(height: 16),
              ],
              // Date Field
              TextFormField(
                focusNode: _dateFocusNode,
                readOnly: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: _selectedDateTime != null
                      ? DateFormat('MMM dd, yyyy').format(_selectedDateTime!)
                      : '',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_timeFocusNode);
                },
              ),
              const SizedBox(height: 16),
              // Time Field
              TextFormField(
                focusNode: _timeFocusNode,
                readOnly: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectTime(context),
                controller: TextEditingController(
                  text: _selectedDateTime != null
                      ? DateFormat('hh:mm a').format(_selectedDateTime!)
                      : '',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_roomFocusNode);
                },
              ),
              const SizedBox(height: 16),
              // Room Field
              TextFormField(
                focusNode: _roomFocusNode,
                controller: _roomController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Room',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_lecturerFocusNode);
                },
              ),
              const SizedBox(height: 16),
              // Lecturer Field
              TextFormField(
                focusNode: _lecturerFocusNode,
                controller: _lecturerController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Lecturer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lecturer name';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_topicFocusNode);
                },
              ),
              const SizedBox(height: 16),
              // Topic Field
              TextFormField(
                focusNode: _topicFocusNode,
                controller: _topicController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Topic',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the topic';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: const Text('Schedule'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
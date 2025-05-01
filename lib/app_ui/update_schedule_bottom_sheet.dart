import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_view_controller.dart';
import '../models/schedule_model.dart';

class UpdateScheduleBottomSheet extends StatefulWidget {
  final String userId;
  final String subjectId;
  final String subjectName;
  final Schedule schedule;

  const UpdateScheduleBottomSheet({
    super.key,
    required this.userId,
    required this.subjectId,
    required this.subjectName,
    required this.schedule,
  });

  @override
  State<UpdateScheduleBottomSheet> createState() => _UpdateScheduleBottomSheetState();
}

class _UpdateScheduleBottomSheetState extends State<UpdateScheduleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime;
  late DateTime _endDateTime;
  late final TextEditingController _roomController;
  late final TextEditingController _lecturerController;
  late final TextEditingController _topicController;
  late final TextEditingController _schoolClassController;
  late final TextEditingController _universityDepartmentController;
  final HomeViewController _controller = HomeViewController();

  late String _institutionType;
  String? _collegeField;
  String? _universitySemester;
  String? _universityShift;

  final _dateFocusNode = FocusNode();
  final _timeFocusNode = FocusNode();
  final _endTimeFocusNode = FocusNode();
  final _roomFocusNode = FocusNode();
  final _lecturerFocusNode = FocusNode();
  final _topicFocusNode = FocusNode();
  final _schoolClassFocusNode = FocusNode();
  final _collegeFieldFocusNode = FocusNode();
  final _universityDepartmentFocusNode = FocusNode();
  final _universitySemesterFocusNode = FocusNode();
  final _universityShiftFocusNode = FocusNode();

  final List<String> _collegeFields = [
    'FA', 'ICS', 'FSc (Pre-Medical)', 'FSc (Pre-Engineering)', 'I.Com',
    'DAE (Electrical)', 'DAE (Mechanical)', 'DAE (Civil)', 'DAE (Electronics)'
  ];

  final List<String> _universitySemesters = [
    '1st', '2nd', '3rd', '4th',
    '5th', '6th', '7th', '8th'
  ];

  final List<String> _universityShifts = ['Morning', 'Evening'];

  @override
  void initState() {
    super.initState();
    // Initialize fields with existing schedule data
    _selectedDateTime = widget.schedule.scheduledDateTime;
    _endDateTime = widget.schedule.endDateTime;
    _roomController = TextEditingController(text: widget.schedule.room);
    _lecturerController = TextEditingController(text: widget.schedule.lecturer);
    _topicController = TextEditingController(text: widget.schedule.topic);
    _institutionType = widget.schedule.institutionType;
    _schoolClassController = TextEditingController(text: widget.schedule.schoolClass);
    _collegeField = widget.schedule.collegeField;
    _universityDepartmentController = TextEditingController(text: widget.schedule.universityDepartment);
    _universitySemester = widget.schedule.universitySemester;
    _universityShift = widget.schedule.universityShift;
  }

  @override
  void dispose() {
    _roomController.dispose();
    _lecturerController.dispose();
    _topicController.dispose();
    _schoolClassController.dispose();
    _universityDepartmentController.dispose();
    _dateFocusNode.dispose();
    _timeFocusNode.dispose();
    _endTimeFocusNode.dispose();
    _roomFocusNode.dispose();
    _lecturerFocusNode.dispose();
    _topicFocusNode.dispose();
    _schoolClassFocusNode.dispose();
    _collegeFieldFocusNode.dispose();
    _universityDepartmentFocusNode.dispose();
    _universitySemesterFocusNode.dispose();
    _universityShiftFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        if (_endDateTime.isBefore(_selectedDateTime)) {
          _endDateTime = _selectedDateTime.add(const Duration(hours: 1));
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        if (_endDateTime.isBefore(_selectedDateTime)) {
          _endDateTime = _selectedDateTime.add(const Duration(hours: 1));
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endDateTime),
    );
    if (picked != null) {
      setState(() {
        final newEndDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        if (newEndDateTime.isAfter(_selectedDateTime)) {
          _endDateTime = newEndDateTime;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End time must be after start time')),
          );
        }
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null && _endDateTime != null) {
      final updatedSchedule = Schedule(
        id: widget.schedule.id,
        scheduledDateTime: _selectedDateTime,
        endDateTime: _endDateTime,
        room: _roomController.text,
        lecturer: _lecturerController.text,
        topic: _topicController.text,
        subjectId: widget.subjectId,
        userId: widget.userId,
        institutionType: _institutionType,
        schoolClass: _institutionType == 'School' ? _schoolClassController.text : null,
        collegeField: _institutionType == 'College' ? _collegeField : null,
        universityDepartment: _institutionType == 'University' ? _universityDepartmentController.text : null,
        universitySemester: _institutionType == 'University' ? _universitySemester : null,
        universityShift: _institutionType == 'University' ? _universityShift : null,
      );
      try {
        await _controller.updateSchedule(updatedSchedule);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update schedule: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields, including start and end time')),
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
                'Update Lecture for ${widget.subjectName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
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
                    _schoolClassController.clear();
                    _collegeField = null;
                    _universityDepartmentController.clear();
                    _universitySemester = null;
                    _universityShift = null;
                  });
                },
              ),
              const SizedBox(height: 16),
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        focusNode: _universitySemesterFocusNode,
                        value: _universitySemester,
                        decoration: const InputDecoration(
                          labelText: 'Semester',
                          border: OutlineInputBorder(),
                        ),
                        items: _universitySemesters.map((String semester) {
                          return DropdownMenuItem<String>(
                            value: semester,
                            child: Text(semester),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _universitySemester = value;
                            FocusScope.of(context).requestFocus(_universityShiftFocusNode);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Select semester';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        focusNode: _universityShiftFocusNode,
                        value: _universityShift,
                        decoration: const InputDecoration(
                          labelText: 'Shift',
                          border: OutlineInputBorder(),
                        ),
                        items: _universityShifts.map((String shift) {
                          return DropdownMenuItem<String>(
                            value: shift,
                            child: Text(shift),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _universityShift = value;
                            FocusScope.of(context).requestFocus(_dateFocusNode);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Select shift';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                            ? DateFormat('MMM dd, yyyy').format(_selectedDateTime)
                            : '',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_timeFocusNode);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      focusNode: _timeFocusNode,
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectTime(context),
                      controller: TextEditingController(
                        text: _selectedDateTime != null
                            ? DateFormat('hh:mm a').format(_selectedDateTime)
                            : '',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_endTimeFocusNode);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      focusNode: _endTimeFocusNode,
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectEndTime(context),
                      controller: TextEditingController(
                        text: _endDateTime != null
                            ? DateFormat('hh:mm a').format(_endDateTime)
                            : '',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_roomFocusNode);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                    child: const Text('Update'),
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
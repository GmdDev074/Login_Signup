import 'package:flutter/material.dart';
import '../controllers/subjects_view_controller.dart';
import '../models/subject_model.dart';

class AddSubjectBottomSheet extends StatefulWidget {
  final String userId;
  final Subject? subject; // Optional subject for updating

  const AddSubjectBottomSheet({
    super.key,
    required this.userId,
    this.subject,
  });

  @override
  State<AddSubjectBottomSheet> createState() => _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState extends State<AddSubjectBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final SubjectsViewController _controller = SubjectsViewController();

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _subjectController.text = widget.subject!.name; // Pre-fill for update
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    if (_formKey.currentState!.validate()) {
      try {
        final subjectName = _subjectController.text.trim();
        if (widget.subject != null) {
          // Update existing subject
          final updatedSubject = Subject(
            id: widget.subject!.id,
            name: subjectName,
            userId: widget.userId,
          );
          await _controller.updateSubject(updatedSubject);
        } else {
          // Add new subject
          final newSubject = Subject(
            name: subjectName,
            userId: widget.userId,
          );
          await _controller.addSubject(newSubject);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save subject: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subject != null ? 'Update Subject' : 'Add Subject',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
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
                    onPressed: _saveSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: Text(widget.subject != null ? 'Update' : 'Add'),
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
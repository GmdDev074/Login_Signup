import 'package:flutter/material.dart';
import '../controllers/profile_update_controller.dart';
import '../models/register_model.dart';

class ProfileUpdateBottomSheet extends StatefulWidget {
  final String userId;
  final UserModel user; // Current user data for updating
  final VoidCallback onProfileUpdated; // Callback to refresh parent

  const ProfileUpdateBottomSheet({
    super.key,
    required this.userId,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileUpdateBottomSheet> createState() => _ProfileUpdateBottomSheetState();
}

class _ProfileUpdateBottomSheetState extends State<ProfileUpdateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final ProfileUpdateController _controller = ProfileUpdateController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name; // Pre-fill with current name
    _numberController.text = widget.user.number; // Pre-fill with current number
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedUser = UserModel(
          name: _nameController.text.trim(),
          number: _numberController.text.trim(),
          email: widget.user.email, // Keep original email
          uid: widget.user.uid, // Keep original uid
        );
        await _controller.updateProfile(updatedUser);
        widget.onProfileUpdated(); // Call callback to refresh parent
        Navigator.pop(context); // Close bottom sheet after successful update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
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
              const Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a phone number';
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
                    onPressed: _saveProfile,
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
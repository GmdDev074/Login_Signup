import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/subjects_view_controller.dart';
import '../models/subject_model.dart';
import 'add_subject_bottom_sheet.dart';
import 'add_schedule_bottom_sheet.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({super.key});

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final SubjectsViewController _controller = SubjectsViewController();
  final User? user = FirebaseAuth.instance.currentUser;

  // Method to delete a subject
  Future<void> _deleteSubject(String subjectId) async {
    try {
      await _controller.deleteSubject(user!.uid, subjectId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete subject: $e')),
      );
    }
  }

  // Method to show the update bottom sheet
  Future<void> _showUpdateSubjectBottomSheet(Subject subject) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddSubjectBottomSheet(
        userId: user!.uid,
        subject: subject, // Pass the subject for updating
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Subject>>(
          stream: _controller.getSubjectsStream(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final subjects = snapshot.data ?? [];

            if (subjects.isEmpty) {
              return const Center(child: Text('No subjects added yet'));
            }

            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final colors = [
                  Colors.orange,
                  Colors.blue.shade200,
                  Colors.red.shade200,
                  Colors.purple.shade200,
                  Colors.green.shade200,
                  Colors.teal.shade200,
                  Colors.amber.shade200,
                  Colors.indigo.shade200,
                  Colors.pink.shade200,
                  Colors.cyan.shade200,
                ];
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Dismissible(
                    key: Key(subject.id!),
                    background: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await _deleteSubject(subject.id!);
                      }
                    },
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        await _showUpdateSubjectBottomSheet(subject);
                        return false; // Prevent dismissal after editing
                      } else if (direction == DismissDirection.endToStart) {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Subject'),
                            content: const Text('Are you sure you want to delete this subject? All associated schedules will also be deleted.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      }
                      return false;
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => AddScheduleBottomSheet(
                            userId: user!.uid,
                            subjectId: subject.id!,
                            subjectName: subject.name,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 80, // Increased card height
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    subject.name[0],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  subject.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddSubjectBottomSheet(userId: user!.uid),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
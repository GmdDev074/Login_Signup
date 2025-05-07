import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/home_view_controller.dart';
import '../models/subject_model.dart';
import '../models/schedule_model.dart';
import '../shimmer_effect_ui/shimmer_effect_home.dart';
import 'add_schedule_bottom_sheet.dart';
import 'add_subject_bottom_sheet.dart';
import 'update_schedule_bottom_sheet.dart';
import 'subjects_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewController _controller = HomeViewController();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> _getSubjectName(String subjectId) async {
    final subjects = await _controller.getSubjectsStream(user!.uid).first;
    final subject = subjects.firstWhere((subject) => subject.id == subjectId, orElse: () => Subject(id: '', name: 'Unknown', userId: user!.uid));
    return subject.name;
  }

  Future<List<Schedule>> _fetchAllSchedules() async {
    final subjects = await _controller.getSubjectsStream(user!.uid).first;
    if (subjects.isEmpty) return [];

    final allSchedules = await Future.wait(subjects.map((subject) async {
      final schedules = await _controller.getSchedulesStream(user!.uid, subject.id!).first;
      return schedules;
    }));

    final flattenedSchedules = allSchedules.expand((x) => x).toList();
    flattenedSchedules.sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
    return flattenedSchedules;
  }

  Future<void> _deleteSchedule(String scheduleId, String subjectId) async {
    try {
      await _controller.deleteSchedule(user!.uid, subjectId, scheduleId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete schedule: $e')),
      );
    }
  }

  Future<void> _showUpdateScheduleBottomSheet(Schedule schedule, String subjectName) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UpdateScheduleBottomSheet(
        userId: user!.uid,
        subjectId: schedule.subjectId,
        subjectName: subjectName,
        schedule: schedule,
      ),
    );
    setState(() {});
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subjects',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'subjects');
                        },
                        child: Text(
                          'Recommendations for you',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<Subject>>(
                    stream: _controller.getSubjectsStream(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show shimmer effect for subjects
                        return SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // Show 3 shimmer placeholders
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ShimmerEffectHome(
                                  height: 140,
                                  width: 100,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final subjects = snapshot.data ?? [];

                      if (subjects.isEmpty) {
                        return const Center(child: Text('No subjects added yet'));
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            final subject = subjects[index];
                            final colors = [
                              Colors.orange,
                              Colors.blue.shade200,
                              Colors.red.shade200,
                              Colors.purple.shade200,
                            ];
                            final color = colors[index % colors.length];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
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
                                child: Container(
                                  width: 100,
                                  height: 140,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(12),
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
                                      const SizedBox(height: 8),
                                      Text(
                                        subject.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Schedule>>(
                    future: _fetchAllSchedules(),
                    builder: (context, scheduleSnapshot) {
                      if (scheduleSnapshot.hasError) {
                        return Center(child: Text('Error: ${scheduleSnapshot.error}'));
                      }
                      if (scheduleSnapshot.connectionState == ConnectionState.waiting) {
                        // Show shimmer effect for schedules
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3, // Show 3 shimmer placeholders
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ShimmerEffectHome(
                                height: 120, // Approximate height of schedule card
                              ),
                            );
                          },
                        );
                      }

                      final allSchedules = scheduleSnapshot.data ?? [];

                      if (allSchedules.isEmpty) {
                        return const Center(child: Text('No schedules available'));
                      }

                      return Column(
                        children: allSchedules.map((schedule) {
                          return FutureBuilder<String>(
                            future: _getSubjectName(schedule.subjectId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const SizedBox.shrink();
                              }
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }

                              final subjectName = snapshot.data!;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Dismissible(
                                  key: Key(schedule.id!),
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
                                      await _deleteSchedule(schedule.id!, schedule.subjectId);
                                    }
                                  },
                                  confirmDismiss: (direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      await _showUpdateScheduleBottomSheet(schedule, subjectName);
                                      return false;
                                    } else if (direction == DismissDirection.endToStart) {
                                      return await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Schedule'),
                                          content: const Text('Are you sure you want to delete this schedule?'),
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
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.book,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                      ),
                                      title: Text(
                                        subjectName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(schedule.lecturer),
                                          const SizedBox(height: 4),
                                          Text('${schedule.date} from ${schedule.time} to ${schedule.endTime}'),
                                          Text('Room: ${schedule.room}'),
                                          if (schedule.topic.isNotEmpty)
                                            Text('Topic: ${schedule.topic}'),
                                          if (schedule.institutionType == 'School' && schedule.schoolClass != null)
                                            Text('Class: ${schedule.schoolClass}'),
                                          if (schedule.institutionType == 'College' && schedule.collegeField != null)
                                            Text('Field: ${schedule.collegeField}'),
                                          if (schedule.institutionType == 'University') ...[
                                            if (schedule.universityDepartment != null)
                                              Text('Department: ${schedule.universityDepartment}'),
                                            if (schedule.universitySemester != null)
                                              Text('Semester: ${schedule.universitySemester}'),
                                            if (schedule.universityShift != null)
                                              Text('Shift: ${schedule.universityShift}'),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
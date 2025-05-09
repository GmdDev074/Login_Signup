import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_view_controller.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';
import '../shimmer_effect_ui/shimmer_effect_schedule.dart';
import 'update_schedule_bottom_sheet.dart';

// Helper widget to draw a vertical dashed line for the timeline
class DashedLineVertical extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashSpace;

  const DashedLineVertical({
    super.key,
    required this.height,
    this.color = Colors.grey,
    this.dashHeight = 5,
    this.dashSpace = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxHeight = constraints.constrainHeight();
          final dashCount = (boxHeight / (dashHeight + dashSpace)).floor();
          return Column(
            children: List.generate(dashCount, (_) {
              return Column(
                children: [
                  Container(
                    width: 1,
                    height: dashHeight,
                    color: color,
                  ),
                  SizedBox(height: dashSpace),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}

class ScheduleWithCalendarViewView extends StatefulWidget {
  const ScheduleWithCalendarViewView({super.key});

  @override
  State<ScheduleWithCalendarViewView> createState() => _ListenViewState();
}

class _ListenViewState extends State<ScheduleWithCalendarViewView> {
  final HomeViewController _controller = HomeViewController();
  final User? user = FirebaseAuth.instance.currentUser;
  DateTime _selectedDate = DateTime.now();

  // Determines if the app is running on web or desktop
  bool get isWebOrDesktop => kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  // Fetches the subject name for a given subject ID
  Future<String> _getSubjectName(String subjectId) async {
    final subjects = await _controller.getSubjectsStream(user!.uid).first;
    final subject = subjects.firstWhere(
          (subject) => subject.id == subjectId,
      orElse: () => Subject(id: '', name: 'Unknown', userId: user!.uid),
    );
    return subject.name;
  }

  // Fetches schedules for the selected date across all subjects
  Future<List<Schedule>> _fetchSchedulesForSelectedDate() async {
    final subjects = await _controller.getSubjectsStream(user!.uid).first;
    if (subjects.isEmpty) return [];

    final allSchedules = await Future.wait(subjects.map((subject) async {
      final schedules = await _controller.getSchedulesStream(user!.uid, subject.id!).first;
      return schedules;
    }));

    final flattenedSchedules = allSchedules.expand((x) => x).toList();
    return flattenedSchedules
        .where((schedule) {
      final scheduleDate = DateTime(
        schedule.scheduledDateTime.year,
        schedule.scheduledDateTime.month,
        schedule.scheduledDateTime.day,
      );
      final selected = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      return scheduleDate == selected;
    })
        .toList()
      ..sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
  }

  // Generates a list of dates for the next 7 days (for mobile)
  List<DateTime> _getWeekDateList() {
    final now = DateTime.now();
    return List.generate(7, (index) => now.add(Duration(days: index)));
  }

  // Generates a list of dates for the entire month (for web/desktop)
  List<DateTime> _getMonthDateList() {
    final now = _selectedDate;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    return List.generate(daysInMonth, (index) => DateTime(now.year, now.month, index + 1));
  }

  // Deletes a schedule with confirmation
  Future<void> _deleteSchedule(String scheduleId, String subjectId) async {
    try {
      await _controller.deleteSchedule(user!.uid, subjectId, scheduleId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete schedule: $e')),
      );
    }
  }

  // Shows the update schedule bottom sheet
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

  // Builds the calendar widget based on platform
  Widget _buildCalendar() {
    if (isWebOrDesktop) {
      return _buildMonthCalendar();
    } else {
      return _buildWeekCalendar();
    }
  }

  // Builds a week-based calendar for mobile
  Widget _buildWeekCalendar() {
    final dateList = _getWeekDateList();
    final isTodaySelected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    ) ==
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                },
                child: Text(
                  isTodaySelected
                      ? 'Today'
                      : DateFormat('EEEE').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dateList.length,
            itemBuilder: (context, index) {
              final date = dateList[index];
              final isSelected = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
              ) ==
                  DateTime(date.year, date.month, date.day);
              final isToday = DateTime(date.year, date.month, date.day) ==
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  );

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange
                        : (isToday ? Colors.green.shade100 : Colors.transparent),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date).substring(0, 3),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Builds a month-based calendar for web/desktop
  Widget _buildMonthCalendar() {
    final dateList = _getMonthDateList();
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;
    final daysInMonth = dateList.length;
    final weeks = (daysInMonth + weekdayOfFirstDay - 1) ~/ 7 + 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Weekday headers
              Row(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
                    .toList(),
              ),
              // Calendar grid
              ...List.generate(weeks, (weekIndex) {
                return Row(
                  children: List.generate(7, (dayIndex) {
                    final dayOffset = weekIndex * 7 + dayIndex - (weekdayOfFirstDay - 1);
                    if (dayOffset < 0 || dayOffset >= daysInMonth) {
                      return Expanded(child: Container());
                    }
                    final date = dateList[dayOffset];
                    final isSelected = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    ) ==
                        DateTime(date.year, date.month, date.day);
                    final isToday = DateTime(date.year, date.month, date.day) ==
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        );

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orange
                                : (isToday ? Colors.green.shade100 : Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Builds the schedule list widget
  Widget _buildScheduleList() {
    return Expanded(
      child: FutureBuilder<List<Schedule>>(
        future: _fetchSchedulesForSelectedDate(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ShimmerEffectSchedule(height: 120),
                );
              },
            );
          }

          final schedules = snapshot.data ?? [];

          if (schedules.isEmpty) {
            return const Center(child: Text('No lectures scheduled for this date'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return FutureBuilder<String>(
                future: _getSubjectName(schedule.subjectId),
                builder: (context, subjectSnapshot) {
                  if (subjectSnapshot.hasError || !subjectSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final subjectName = subjectSnapshot.data!;

                  return Dismissible(
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
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  schedule.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Expanded(
                                  child: DashedLineVertical(
                                    dashHeight: 5,
                                    dashSpace: 3,
                                    color: Colors.grey,
                                    height: 10,
                                  ),
                                ),
                                Text(
                                  schedule.endTime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subjectName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.description, size: 16, color: Colors.black),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Topic: ${schedule.topic.isNotEmpty ? schedule.topic : 'No topic specified'}',
                                            style: const TextStyle(fontSize: 14, color: Colors.black),
                                            softWrap: true,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.meeting_room, size: 16, color: Colors.black),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Room: ${schedule.room}',
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 16, color: Colors.black),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Lecturer: ${schedule.lecturer}',
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (schedule.institutionType == 'School' && schedule.schoolClass != null)
                                      Row(
                                        children: [
                                          const Icon(Icons.class_, size: 16, color: Colors.black),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Class: ${schedule.schoolClass}',
                                              style: const TextStyle(fontSize: 12, color: Colors.black),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (schedule.institutionType == 'College' && schedule.collegeField != null)
                                      Row(
                                        children: [
                                          const Icon(Icons.school, size: 16, color: Colors.black),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Field: ${schedule.collegeField}',
                                              style: const TextStyle(fontSize: 12, color: Colors.black),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (schedule.institutionType == 'University') ...[
                                      if (schedule.universityDepartment != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.account_balance, size: 16, color: Colors.black),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                'Department: ${schedule.universityDepartment}',
                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 4),
                                      if (schedule.universitySemester != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 16, color: Colors.black),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Semester: ${schedule.universitySemester}',
                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 4),
                                      if (schedule.universityShift != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.schedule, size: 16, color: Colors.black),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Shift: ${schedule.universityShift}',
                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
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
      body: isWebOrDesktop
          ? Row(
        children: [
          // Calendar on the left for web/desktop
          Container(
            width: 400,
            padding: const EdgeInsets.all(16.0),
            child: _buildCalendar(),
          ),
          // Schedule list on the right
          Expanded(child: _buildScheduleList()),
        ],
      )
          : Column(
        children: [
          // Calendar on top for mobile
          _buildCalendar(),
          // Schedule list below
          _buildScheduleList(),
        ],
      ),
    );
  }
}
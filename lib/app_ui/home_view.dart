import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../controllers/home_view_controller.dart';
import '../models/alarm_model.dart';
import '../models/note_model.dart';
import 'create_item_bottom_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewController _controller = HomeViewController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.green.shade700,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Notes'),
              Tab(text: 'Alarms'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Notes Section
            StreamBuilder<QuerySnapshot>(
              stream: _controller.getNotesStream(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notes = snapshot.data!.docs
                    .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                if (notes.isEmpty) {
                  return const Center(child: Text('No notes available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Dismissible(
                      key: Key(note.id!),
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
                          await _controller.deleteNote(user!.uid, note.id!);
                        }
                      },
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await _showUpdateNoteBottomSheet(context, note);
                          return false;
                        }
                        return direction == DismissDirection.endToStart;
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.description),
                              Text(
                                'Created: ${DateFormat('MMM dd, yyyy HH:mm').format(note.createdAt)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Alarms Section
            StreamBuilder<QuerySnapshot>(
              stream: _controller.getAlarmsStream(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final alarms = snapshot.data!.docs
                    .map((doc) => Alarm.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                if (alarms.isEmpty) {
                  return const Center(child: Text('No alarms available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    final remainingTime = alarm.scheduledTime.difference(DateTime.now());
                    final remainingText = remainingTime.isNegative
                        ? 'Triggered'
                        : '${remainingTime.inHours}h ${remainingTime.inMinutes % 60}m remaining';

                    return Dismissible(
                      key: Key(alarm.id!),
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
                          await _controller.deleteAlarm(user!.uid, alarm.id!);
                        }
                      },
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await _showUpdateAlarmBottomSheet(context, alarm);
                          return false;
                        }
                        return direction == DismissDirection.endToStart;
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(alarm.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Scheduled: ${DateFormat('MMM dd, yyyy HH:mm').format(alarm.scheduledTime)}'),
                              Text('Status: $remainingText', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade700,
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => CreateItemBottomSheet(userId: user!.uid),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showUpdateNoteBottomSheet(BuildContext context, Note note) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateItemBottomSheet(
        userId: user!.uid,
        note: note,
      ),
    );
  }

  Future<void> _showUpdateAlarmBottomSheet(BuildContext context, Alarm alarm) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateItemBottomSheet(
        userId: user!.uid,
        alarm: alarm,
      ),
    );
  }
}
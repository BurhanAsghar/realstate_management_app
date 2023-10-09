import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: TaskScreen(),
  ));
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _tasknameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
  TextEditingController();
  final CollectionReference _tasksCollection =
  FirebaseFirestore.instance.collection('Tasks');

  Future<void> _createTask() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _tasknameController,
                decoration: const InputDecoration(labelText: 'Task Name:'),
              ),
              TextField(
                controller: _taskDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Create Task'),
                onPressed: () async {
                  final String taskname = _tasknameController.text;
                  final String taskdescription =
                      _taskDescriptionController.text;

                  if (taskdescription.isNotEmpty) {
                    await _tasksCollection.add({
                      'userId': userId,
                      'taskname': taskname,
                      'taskdescription': taskdescription,
                    });

                    _tasknameController.text = '';
                    _taskDescriptionController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateTask(DocumentSnapshot documentSnapshot) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentUserUid = user?.uid;

    if (currentUserUid == documentSnapshot['userId']) {
      _tasknameController.text = documentSnapshot['taskname'];
      _taskDescriptionController.text =
          documentSnapshot['taskdescription'].toString();

      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _tasknameController,
                  decoration: const InputDecoration(labelText: 'Task Name:'),
                ),
                TextField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update Task'),
                  onPressed: () async {
                    final String taskname = _tasknameController.text;
                    final String taskdescription =
                        _taskDescriptionController.text;

                    if (taskdescription.isNotEmpty) {
                      await _tasksCollection
                          .doc(documentSnapshot.id)
                          .update({
                        'taskname': taskname,
                        'taskdescription': taskdescription,
                      });

                      _tasknameController.text = '';
                      _taskDescriptionController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final user = FirebaseAuth.instance.currentUser;
    final currentUserUid = user?.uid;

    final taskSnapshot =
    await _tasksCollection.doc(taskId).get();

    if (currentUserUid == taskSnapshot['userId']) {
      await _tasksCollection.doc(taskId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have successfully deleted a task'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createTask,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _tasksCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['taskname']),
                    subtitle:
                    Text(documentSnapshot['taskdescription'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _updateTask(documentSnapshot),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteTask(documentSnapshot.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

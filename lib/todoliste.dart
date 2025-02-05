import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_app/widgets/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Todoliste extends StatefulWidget {
  const Todoliste({super.key});

  @override
  State<Todoliste> createState() => _TodolisteState();
}

class _TodolisteState extends State<Todoliste> {
  final FirestoreService firestoreService = FirestoreService();

  void _confirmDeleteTask(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la tâche"),
        content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              firestoreService.deleteTask(taskId);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(
          IconsaxPlusLinear.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getTasks(),
            builder: (context, snapshot) {
              int taskCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildHeader(taskCount);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: firestoreService.getTasks(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tasks = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task['isCompleted'],
                        onChanged: (value) {
                          firestoreService.updateTask(task.id, value!);
                        },
                      ),
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          decoration: task['isCompleted']
                              ? TextDecoration.lineThrough
                              : null, // 🏷️ Barre si complété
                        ),
                      ),
                      subtitle: Text(
                        task['description'],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(IconsaxPlusBold.brush_2,
                                color: Colors.blue),
                            onPressed: () => _showEditTaskDialog(context, task),
                          ),
                          IconButton(
                            icon: const Icon(IconsaxPlusBold.close_square,
                                color: Colors.red),
                            onPressed: () =>
                                _confirmDeleteTask(context, task.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int taskCount) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 90, left: 30, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(IconsaxPlusLinear.clipboard_text,
                    color: Colors.blue, size: 40)),
            Text(
              "All",
              style: GoogleFonts.lato(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "$taskCount Tâches",
              style: GoogleFonts.lato(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter une tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: descriptionController,
              maxLength: 100,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Retour")),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                firestoreService.addTask(
                    titleController.text, descriptionController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, DocumentSnapshot task) {
    TextEditingController titleController =
        TextEditingController(text: task['title']);
    TextEditingController descriptionController =
        TextEditingController(text: task['description']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier la tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: descriptionController,
              maxLength: 100,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              firestoreService.updateTaskDetails(
                  task.id, titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }
}

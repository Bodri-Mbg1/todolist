import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // 🔹 Ajouter une tâche
  Future<void> addTask(String title, String description) {
    return tasksCollection.add({
      'title': title,
      'description': description,
      'isCompleted': false, // Par défaut, non complété
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Lire les tâches (Stream)
  Stream<QuerySnapshot> getTasks() {
    return tasksCollection.orderBy('createdAt', descending: true).snapshots();
  }

  // 🔹 Mettre à jour l'état d'une tâche (complétée ou non)
  Future<void> updateTask(String taskId, bool isCompleted) {
    return tasksCollection.doc(taskId).update({'isCompleted': isCompleted});
  }

  // 🔹 Modifier le titre et la description d'une tâche
  Future<void> updateTaskDetails(
      String taskId, String newTitle, String newDescription) {
    return tasksCollection.doc(taskId).update({
      'title': newTitle,
      'description': newDescription,
    });
  }

  // 🔹 Supprimer une tâche
  Future<void> deleteTask(String taskId) {
    return tasksCollection.doc(taskId).delete();
  }
}

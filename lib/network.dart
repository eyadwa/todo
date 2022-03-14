import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/todo_item.dart';
class Network {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference? todoCollection;

  Network() {
    // Offline Access
    firestore.settings = const Settings(persistenceEnabled: false);

    todoCollection = firestore.collection("todo");
  }

  void getTodoList() {
    todoCollection?.snapshots().forEach(
      (element) {
        for (var doc in element.docs) {
          print("${doc.get("Name")}");
        }
      },
    );
  }

  void createTodoItem(TodoItem item) {
    firestore.collection("images").add(item.toJson());
  }
}

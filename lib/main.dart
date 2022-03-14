import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/cloudinary_response.dart';
import 'package:todoapp/todo_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

import 'network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() async {
      final ImagePicker _picker = ImagePicker();
      var xFile = await _picker.pickImage(source: ImageSource.gallery);

      var path = xFile?.path;
      if (path == null) {
        return;
      }

      var postUri =
          Uri.parse("https://api.cloudinary.com/v1_1/micksawy3r/image/upload");

      var request = http.MultipartRequest("POST", postUri);

      request.fields["api_key"] = "165569146427747";
      request.fields["timestamp"] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields["upload_preset"] = "unsigned_upload";

      var uploadFile = await http.MultipartFile.fromPath('file', path);
      request.files.add(uploadFile);

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((event) {
        var cloudinaryResponse = CloudinaryResponse.fromJson(event);

        var network = Network();
        var todoItem = TodoItem("Image Node", DateTime.now(), imageUrl: cloudinaryResponse.url);
        network.createTodoItem(todoItem);
        print("Got Response $event");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

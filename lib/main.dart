import 'package:flutter/material.dart';
import 'package:sound/screens/Home.dart';
import 'package:sound/screens/Upload.dart';
import 'package:firebase_core/firebase_core.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentindex = 0;
  List tabs=[
    Home(),
    Upload(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sound app"),
        ),
        body: tabs[currentindex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentindex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload),
              title: Text("Upload"),
            ),
          ],
          onTap: (index){
            setState(() {
              currentindex=index;
            });
          },

        ),
      ),
    );
  }
}

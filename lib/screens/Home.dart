import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sound/screens/Lecturepage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getData() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('lecture').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Lecturepage(
                        lecture_name:snapshot.data[index].data["lecture_name"],
                        lecturer_name:snapshot.data[index].data["lecturer_name"],
                        lecture_url:snapshot.data[index].data["lecture_url"],
                        image_url:snapshot.data[index].data["image_url"],
                      ))),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        snapshot.data[index].data["lecture_name"],
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                );
              });
        }
      },
    );
  }
}

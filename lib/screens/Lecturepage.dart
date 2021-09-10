import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sound/screens/Upload.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class Lecturepage extends StatefulWidget {
  String? lecture_name, lecturer_name, lecture_url, image_url;
  Lecturepage(
      {this.lecture_name,
      this.lecturer_name,
      this.image_url,
      this.lecture_url});

  @override
  _LecturepageState createState() => _LecturepageState();
}

class _LecturepageState extends State<Lecturepage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;
  bool isplaying = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
      advancedPlayer.notificationService.startHeadlessService();
    }
  }

  Future<void> startHeadlessServise() async {
    advancedPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sound Lecture"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              widget.lecture_name.toString(),
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              widget.lecturer_name.toString(),
              style: TextStyle(fontSize: 25.0),
            ),
            Card(
              child: Image.network(
                widget.lecture_url.toString(),
                height: 350.0,
              ),
              elevation: 10.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100.0,
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isplaying = true;
                      });
                      await advancedPlayer.notificationService
                          .startHeadlessService();
                      await advancedPlayer.notificationService.setNotification(
                        title: '',
                        albumTitle: '',
                        artist: '',
                        imageUrl: widget.image_url.toString(),
                        forwardSkipInterval: const Duration(seconds: 30),
                        backwardSkipInterval: const Duration(seconds: 30),
                        duration: const Duration(minutes: 3),
                        elapsedTime: const Duration(seconds: 15),
                        enableNextTrackButton: true,
                        enablePreviousTrackButton: true,
                      );
                      await advancedPlayer.play(
                        widget.lecture_url.toString(),
                        isLocal: false,
                      );
                    },
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: isplaying == true ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isplaying=false;
                      });
                      await advancedPlayer.stop();
                    },
                    child: Icon(
                      Icons.stop,
                      size: 50.0,
                      color: isplaying == true ? Colors.black : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

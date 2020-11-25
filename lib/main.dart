import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  var playerState = FlutterRadioPlayer.flutter_radio_paused;

  var volume = 0.8;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();

  @override
  void initState() {
    super.initState();
    initRadioService();
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init("Flutter Radio Example", "Live",
          "https://radioislamindonesia.com:7002/;", "false");
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Radio Islami'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Icon(
                  Icons.radio,
                  size: 250,
                  color: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Icon(Icons.volume_up_sharp, color: Colors.blue,),
                    Expanded(
                      child: Slider(
                          value: widget.volume,
                          min: 0,
                          max: 1.0,
                          onChanged: (value) => setState(() {
                                widget.volume = value;
                                _flutterRadioPlayer.setVolume(widget.volume);
                              })),
                    ),
                  ],
                ),
              ),
              /*Text("Volume: " + (widget.volume * 100).toStringAsFixed(0)),
              SizedBox(
                height: 15,
              ),
              Text("Metadata Track "),
              StreamBuilder<String>(
                initialData: "",
                stream: _flutterRadioPlayer.metaDataStream,
                builder: (context, snapshot) {
                  return Text(snapshot.data);
                },
              ),*/
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                    child: StreamBuilder(
                        stream: _flutterRadioPlayer.isPlayingStream,
                        initialData: widget.playerState,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          String returnData = snapshot.data;
                          print("object data: " + returnData);
                          switch (returnData) {
                            case FlutterRadioPlayer.flutter_radio_stopped:
                              return RaisedButton(
                                  child: Text("Start listening now"),
                                  onPressed: () async {
                                    await initRadioService();
                                  });
                              break;
                            case FlutterRadioPlayer.flutter_radio_loading:
                              return Text("Loading stream...");
                            case FlutterRadioPlayer.flutter_radio_error:
                              return RaisedButton(
                                  child: Text("Retry ?"),
                                  onPressed: () async {
                                    await initRadioService();
                                  });
                              break;
                            default:
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton(
                                        onPressed: () async {
                                          print("button press data: " +
                                              snapshot.data.toString());
                                          await _flutterRadioPlayer
                                              .playOrPause();
                                        },
                                        child: snapshot.data ==
                                                FlutterRadioPlayer
                                                    .flutter_radio_playing
                                            ? Icon(Icons.pause)
                                            : Icon(Icons.play_arrow)),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    FloatingActionButton(
                                        onPressed: () async {
                                          await _flutterRadioPlayer.stop();
                                        },
                                        child: Icon(Icons.stop))
                                  ]);
                              break;
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

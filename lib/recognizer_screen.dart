import 'package:flutter/material.dart';
import 'constants.dart';
import 'darwing_painter.dart';
import 'brain.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RecognizerScreen extends StatefulWidget {
  RecognizerScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecognizerScreen createState() => _RecognizerScreen();
}

enum TtsState { playing, stopped }

class _RecognizerScreen extends State<RecognizerScreen> {
  List<Offset> points = List();
  AppBrain brain = AppBrain();
  String footerText = "Waiting for Result";
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    brain.loadModel();
    resetLabel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3.0,
                  color: Colors.black,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (details) async {
                      points.add(null);
                      List predictions =
                          await brain.processCanvasPoints(points);
                      print(predictions);
                      _speak(predictions.first['label']);
                      setState(() {
                        _setLabelsForGuess(predictions.first['label']);
                      });
                    },
                    child: ClipRect(
                      child: CustomPaint(
                        size: Size(kCanvasSize, kCanvasSize),
                        painter: DrawingPainter(
                          offsetPoints: points,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 32.0, 0, 64.0),
              child: Text(
                footerText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearScreen();
        },
        tooltip: 'Clear',
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _clearScreen() {
    setState(() {
      points = List();
      resetLabel();
    });
  }

  void resetLabel() {
    footerText = "Waiting for result";
  }

  void _setLabelsForGuess(String guess) {
    footerText = "The predicted value is " + guess;
  }

  Future _speak(String spoken) async {
    await flutterTts.setVolume(2.0);
    await flutterTts.speak("The predicted value is" + spoken);
  }
}

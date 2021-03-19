import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

int blackDiamondFound = 0;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Picker(),
    );
  }
}

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  int pressedCnt = 0;
  var random = Random();
  List<String> imagePaths = [
    'rock.png',
    'bluering.png',
    'bluefruit.png',
    'egg.png',
    'poo.png',
    'redring.png',
    'bronzecoin.png',
    'sword.jpg',
    'silvercoin.png',
    'shield.png',
    'crap.jpg',
    'books.png'
  ];
  String imagePath = 'rock.png';
  bool secretImage = false;
  String image() {
    var rn = random.nextInt(1000);
    if (rn >= 11 && rn <= 20) {
      incrementPreciousCount();
      return 'crown.png';
    } else if (rn == 747) {
      secretImage = true;
      blackDiamondIncrement();
      return 'blackdiamond.jpg';
    }
    return imagePaths[random.nextInt(imagePath.length)];
  }

  int preciousCnt = 0;
  void incrementPreciousCount() {
    preciousCnt++;
  }

  void blackDiamondIncrement() {
    blackDiamondFound++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: blackDiamondFound > 0
          ? AppBar(
              backgroundColor: Colors.amber,
              title: Center(child: ColorfulBlackDiamondCount()),
            )
          : null,
      backgroundColor: Colors.white,
      floatingActionButton: InkWell(
        splashColor: Color(0xFFf7f448),
        onLongPress: () {
          setState(() {
            preciousCnt = 0;
            pressedCnt = 0;
            secretImage = false;
            blackDiamondFound = 0;
          });
        },
        child: FloatingActionButton(
          child: FaIcon(FontAwesomeIcons.redo),
          backgroundColor: Colors.yellow,
          onPressed: () {
            setState(() {
              preciousCnt = 0;
              pressedCnt = 0;
              secretImage = false;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '무료 뽑기',
                style: TextStyle(
                  fontFamily: 'UhBeeARyong',
                  fontWeight: FontWeight.bold,
                  fontSize: 100.0,
                ),
              ),
              secretImage
                  ? Text('숨겨진 보석을 찾았습니다!', style: TextStyle(fontSize: 20.0))
                  : SizedBox(),
              Text(
                '보석 수: $preciousCnt',
                style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'UhBeeARYong',
                ),
              ),
              Image.asset(
                'images/$imagePath',
                width: 200.0,
                height: 200.0,
              ),
              RaisedButton(
                child: Text(
                  '뽑기!',
                  style: TextStyle(fontFamily: 'UhBeeARyong', fontSize: 30.0),
                ),
                color: Color(0xFFffaa00),
                onPressed: () {
                  setState(() {
                    if (!secretImage) imagePath = image();
                    pressedCnt += 1;
                  });
                },
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
              ),
              Text(
                '$pressedCnt',
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColorfulBlackDiamondCount extends StatefulWidget {
  @override
  _ColorfulBlackDiamondCountState createState() =>
      new _ColorfulBlackDiamondCountState();
}

class _ColorfulBlackDiamondCountState extends State<ColorfulBlackDiamondCount>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..forward()
      ..repeat();

    animation = bgColor.animate(_controller);
  }

  Animatable<Color> bgColor = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.red, end: Colors.blue),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.blue, end: Colors.green),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.green, end: Colors.yellow),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.yellow, end: Colors.red),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Text('숨겨진 보석 개수 $blackDiamondFound개',
              style: TextStyle(color: animation.value));
        });
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

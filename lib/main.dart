import 'dart:async';

import 'package:flutter/material.dart';

import 'Widget/index.dart';
import 'router.dart';

void main() async{
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      initialRoute : '/home',
    );
  }
}
class home extends StatefulWidget {

  @override
  State<home> createState() => _homeState();
}


class _homeState extends State<home> {

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Home();
    }
 Home()async{
  var duration = Duration(seconds:4);
  return Timer(duration, route);

}
route(){
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context)=> Index()));
}

double screenW=0.0, screenH=0.0;
  @override
  Widget build(BuildContext context) {
        screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
                 color: Colors.white,
        child: Center(
          child: Container(
             height: screenH * 0.9,
              width: screenW * 0.7,
            child: Image.asset('images/logo easyprint.png')),
        ),
      )
      );

  }
}



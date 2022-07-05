import 'dart:io';

import 'package:flutter/material.dart';

import 'link.dart';

class Quantity extends StatefulWidget {
   File? imgFile;
  Quantity({
     this.imgFile,
  });

  @override
  State<Quantity> createState() => _QuantityState();
}
double screenW = 0.0, screenH = 0.0;
bool Maddle = false;
bool Dark = false;

class _QuantityState extends State<Quantity> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          appber(),
          Print_P(),
          Print_C(),
          Print_D(),
          RaisedButton(
             onPressed: () async {
                 Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Link1(imgFile:widget.imgFile),),
                    );
              },
            color: Colors.blue[200],
            child: Text(
              'OK',
              style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
            ),
          )
        ],
      ),
    );
  }

  Container Print_D() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Print Darkness :",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                  width: 90,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      'Maddle',
                      style: TextStyle(
                          color: Maddle ? Colors.white70 :  Color(0xff00aaf8),
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Maddle ?  Color(0xff00aaf8) : Colors.white38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      setState(() {
                        Maddle = !Maddle;
                        Maddle = true;
                        Dark = false;
                      });
                    },
                  ),
                ),
                Container(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      'Dark',
                      style: TextStyle(
                          color: Dark ? Colors.white70 :  Color(0xff00aaf8), fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Dark ?  Color(0xff00aaf8) : Colors.white38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      setState(() {
                        Dark = !Dark;
                        Dark = true;
                        Maddle = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
                width: screenW * 0.8, height: screenH * 0.01, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Container Print_C() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Print Copies : ",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                    margin: EdgeInsets.only(left: 40),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: screenW * 0.2,
                    child: TextFormField(
                      style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                    )),
              ],
            ),
            Container(
                width: screenW * 0.8, height: screenH * 0.01, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Container Print_P() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Print_Page : ",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: screenW * 0.2,
                      child: TextFormField(
                        style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                        textAlign: TextAlign.left,
                      )
                      ),
                ),
                Expanded(
                  child: Text(
                    "- ",
                    style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Container(
                width: screenW * 0.8, height: screenH * 0.01, color: Colors.black),
          ],
        ),
      ),
    );
  }

    Container appber() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      height: 80,
      width: screenW * 1,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 2),
              // height: screenH * 0.15,
              // width: screenW * 0.08,
              height: 70,
              width: 70,
              decoration:
                  ShapeDecoration(color:  Color(0xff00aaf8), shape: CircleBorder())),
          Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Container(
                    height: 45,
                    // width: screenW * 0.8,
                    // color: Colors.amber,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 17,
                      ),
                      child: Container(
                        child: Text(
                          'Easyprint',
                          style: TextStyle(
                              fontSize: 25,
                              color:  Color(0xff00aaf8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 35),
                  child: Container(
                    height: 35,
                    // width: screenW * 0.2,
                    // color: Colors.green,
                    child: Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Log in >",
                          style:
                              TextStyle(fontSize: 17, color:  Color(0xff00aaf8)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

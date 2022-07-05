import 'dart:io';

import 'package:flutter/material.dart';

import 'bluetooth.dart';

class Link1 extends StatefulWidget {
    File? imgFile;
  Link1({
     this.imgFile,
  });
  @override
  State<Link1> createState() => _LinkState();
}

 double screenW=0.0, screenH=0.0;
class _LinkState extends State<Link1> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appber(),
            SizedBox(height: 50.0),
            USB(),
            SizedBox(height: 50.0),
            WIFI(),
            SizedBox(height: 50.0),
            Bluetooth(),
          ],
        ),
      ),
    );
  }

  Container USB() {
    return Container(
      height: screenH * 0.15,
      width: screenW * 0.8,
      child: RaisedButton(
        onPressed: () => {Navigator.pushNamed(context, '/index')},
        color:  Color(0xff00aaf8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded (
              child: Text(
                'USB',
                style: TextStyle(color: Colors.white, fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50.0),
            Icon(
              Icons.usb,
              color: Colors.white,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

  Container WIFI() {
    return Container(
      height: screenH * 0.15,
      width: screenW * 0.8,
      color:  Color(0xff00aaf8),
      child: RaisedButton(
        onPressed: () => {Navigator.pushNamed(context, '/index')},
        color:  Color(0xff00aaf8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'WIFI',
                style: TextStyle(color: Colors.white, fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50.0),
            Icon(
              Icons.wifi_outlined,
              color: Colors.white,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

  Container Bluetooth() {
    return Container(
      height: screenH * 0.15,
      width: screenW * 0.8,
      child: RaisedButton(
        onPressed: () async {
          print(widget.imgFile);
                 Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Bluetooth1(imgFile:widget.imgFile),),
                    );
              },
        color:  Color(0xff00aaf8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Bluetooth',
                style: TextStyle(color: Colors.white, fontSize: 45),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(
              Icons.bluetooth,
              color: Colors.white,
              size: 55,
            ),
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
      // color: Colors.black,
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

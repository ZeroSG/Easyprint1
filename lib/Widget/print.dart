import 'package:flutter/material.dart';

class print1 extends StatefulWidget {
  
  @override
  State<print1> createState() => _print1State();
}

double screenW=0.0, screenH=0.0;

class _print1State extends State<print1> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          appber(),
          Width(),
          Height(),
          Length(),
          RaisedButton(
            onPressed: () => {Navigator.pushNamed(context, '/showPDF')},
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

  Container Length() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "    Gap Length  :",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: screenW * 0.13,
                    child: TextFormField()),
                Text(
                  "mm ",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                  width: screenW * 0.12,
                  height: screenH * 0.05,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '-',
                      style: TextStyle(color:  Color(0xff00aaf8), fontSize: 30),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Container(
                  width: screenW * 0.12,
                  height: screenH * 0.05,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '+',
                      style: TextStyle(color:  Color(0xff00aaf8), fontSize: 30),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
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

  Container Height() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(

          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "   Label Height :",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: screenW * 0.13,
                    child: TextFormField()),
                Text(
                  "mm ",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
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

  Container Width() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "   Label Width  :",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
                ),
                Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: screenW * 0.13,
                    child: TextFormField()),
                Text(
                  "mm ",
                  style: TextStyle(color:  Color(0xff00aaf8), fontSize: 25),
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

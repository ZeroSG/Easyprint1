import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Index extends StatefulWidget {
  @override
  State<Index> createState() => _IndexState();
}

double screenW = 0.0, screenH = 0.0;

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [appber(), Images(), Rowmenu()],
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
                  ShapeDecoration(color: Color(0xff00aaf8), shape: CircleBorder())),
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
                              color: Color(0xff00aaf8),
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
                              TextStyle(fontSize: 17, color:Color(0xff00aaf8)),
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

  Container Images() {
    return Container(
      height: screenH * 0.3,
      width: screenW * 1,
      color: Colors.blueAccent,
      child:  Container(
      //   height: screenH * 0.2,
      // width: screenW * 100,
        child: Image.asset('images/Untitled-2.jpg',fit: BoxFit.fill,)),
    );
  }

  Container Rowmenu() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () async {
                String LineUrl = 'https://line.me/R/nv/chat';
                if (await canLaunch(LineUrl)) {
                  await launch(LineUrl);
                } else {
                  Navigator.pushNamed(context, '/index');
                }
              },
              child: Container(
                width: screenW * 0.3,
                height: screenH * 0.22,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: screenH * 0.15,
                        width: screenW * 0.3,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("images/pngwing.jpg"),
                            fit: BoxFit.fill,
                          ),
                          shape: CircleBorder(),
                          shadows: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: new Offset(10.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                        )),
                    Text(
                      'สั่งกระดาษเครื่องพิมพ์',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff00aaf8),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/file');
              },
              child: Container(
                width: screenW * 0.3,
                height: screenH * 0.22,
                child: Column(
                  children: <Widget>[
                   Container(
                        height: screenH * 0.15,
                        width: screenW * 0.3,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("images/pngtree-vector-documents-icon-png-image_553771-removebg-preview.jpg"),
                            fit: BoxFit.fill,
                          ),
                          shape: CircleBorder(),
                          shadows: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: new Offset(10.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                        )),
                    Text(
                      'สร้างเอกสารใหม่',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff00aaf8),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/print');
              },
              child: Container(
                width: screenW * 0.3,
                height: screenH * 0.22,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: screenH * 0.15,
                        width: screenW * 0.3,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("images/order-printer-paper-removebg-preview.jpg"),
                            fit: BoxFit.fill,
                          ),
                          shape: CircleBorder(),
                          shadows: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: new Offset(10.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                        )),
                    Text(
                      'พิมพ์',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff00aaf8),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

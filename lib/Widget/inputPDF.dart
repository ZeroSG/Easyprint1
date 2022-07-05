import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../ex/PDF.dart';
import 'size.dart';

class newDocumentPDF extends StatefulWidget {
  String? PDF;
  String? size;
  double? h;
  double? w;
  double? w1;
  String? PATH, PopUp;

  newDocumentPDF(
      {Key? key,
      this.PDF,
      this.size,
      this.h,
      this.w,
      this.w1,
      this.PATH,
      this.PopUp})
      : super(key: key);
  @override
  State<newDocumentPDF> createState() => _newDocumentPDFState();
}

var pdf;
var FPDF = "PDF";
bool _chexcked = false;
double screenW = 0.0, screenH = 0.0;
String? a, b;
var str = '';
final image = pw.MemoryImage(
  File('/data/user/0/com.flutterthailand.easyprint1/app_flutter/images/100x150.jpg').readAsBytesSync(),
);
wonPdf1() async {
  pdf = pw.Document();
  str = _input.text;
  var str1 = _input1.text;
  var Font = pw.Font.ttf(await rootBundle.load("fonts/THSarabun.ttf"));
  for (var word in str.split("#")) {
    try {
      pdf.addPage(
        pw.MultiPage(
            theme: pw.ThemeData.withFont(base: Font),
            pageFormat: PDF,
            margin: pw.EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            build: (pw.Context context) {
              return <pw.Widget>[
                pw.Stack(
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(left: w!),
                      width: w1,
                      height: h,
                      child: pw.Text(
                        'ผู้ส่ง\n $str1',
                        style: pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.only(top: 5),
                      width: w,
                      //  height: 50,
                      child: pw.Text('$word',
                          style: pw.TextStyle(
                            fontSize: 15,
                          )),
                    ),
                  ],
                )
              ];
            }),
      );
    } catch (e) {
      print('e ===> ${e.toString()} ');
      a = e.toString();
      b = '${e.toString()}$word';
    }
  }
}

wonPdf() async {
  pdf = pw.Document();
  str = _input.text;
  var Font = pw.Font.ttf(await rootBundle.load("fonts/THSarabun.ttf"));
  for (var word in str.split("#")) {
    try {
      pdf.addPage(
        pw.MultiPage(
            theme: pw.ThemeData.withFont(base: Font),
            pageFormat: PDF,
            margin: pw.EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            build: (pw.Context context) {
              return <pw.Widget>[
                //  pw.Image(image)
                pw.Text(word,
                    style: pw.TextStyle(
                      fontSize: 15,
                    )),
              ];
            }),
      );

    } catch (e) {
      print('e ===> ${e.toString()} ');
      a = e.toString();
      b = '${e.toString()}$word\n\n';
    }
    print(PDF);
  }
}

Future savePDF(String folderName) async {
  Directory documentDiresctory = await getApplicationDocumentsDirectory();
  final now = DateTime.now();
  String documentPath = documentDiresctory.path;
   Directory _appDocDirFolder = Directory("$documentPath/$folderName/");
   var isThere = await _appDocDirFolder.exists();
     print(isThere ? 'exists' : 'non-existent');
     if(isThere != true){
         Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
         print('==================>เพิ่มสำเร็จ');
     }else{
       print('==================>มีอยู่เล้ว');
     }
  File file =
      File("$documentPath/$folderName/Label_${now.day}-${now.month}-${now.year}_$size.pdf");
  file.writeAsBytesSync(await pdf.save());
  print(file.path);
}

String namefile = '';
final TextEditingController _input = TextEditingController();
final TextEditingController _input1 = TextEditingController();

class _newDocumentPDFState extends State<newDocumentPDF> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 18),
        width: screenW * 1,
        height: screenH * 1,
        color: Color(0xff00aaf8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              appber(),
              recipient(),
              recipient2(),
              sender(),
              sender2(),
              CANCLE_OK(context)
            ],
          ),
        ),
      ),
    );
  }

  Container CANCLE_OK(BuildContext context) {
    return Container(
      width: screenW * 0.85,
      height: screenH * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/index');
            },
            color: Colors.white,
            child: Text(
              'CANCLE',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              if (_chexcked != true) {
                setState(() {
                  a = 'ไม่มีอะไรผิด';
                });
                await wonPdf();
                if (a != 'ไม่มีอะไรผิด') {
                  //  print('สำเร็จ $a');
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: Container(
                              height: 400,
                              width: 300,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 300,
                                        width: 300,
                                        child: SingleChildScrollView(
                                            child: Center(child: Text(b!)))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Colors.blue,
                                          child: Text(
                                            'CANCLE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            await savePDF(FPDF);
                                            Directory documentDiresctory =
                                                await getApplicationDocumentsDirectory();
                                            final now = DateTime.now();
                                            String documentPath =
                                                documentDiresctory.path;
                                            namefile =
                                                "$documentPath/PDF/Label_${now.day}-${now.month}-${now.year}_$size.pdf";
                                            pdf = null;
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => PDFD(
                                            //               path: namefile,
                                            //             )));
                                          },
                                          color: Colors.blue,
                                          child: Text(
                                            'OK',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]))));
                } else {
                  await savePDF(FPDF);
                  Directory documentDiresctory =
                      await getApplicationDocumentsDirectory();
                  final now = DateTime.now();
                  String documentPath = documentDiresctory.path;
                  namefile =
                      "$documentPath/PDF/Label_${now.day}-${now.month}-${now.year}_$size.pdf";
                  pdf = null;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PDFD(
                  //               path: namefile,
                  //             )));
                }
              } else {
                setState(() {
                  a = 'ไม่มีอะไรผิด';
                });
                await wonPdf1();
                if (a != 'ไม่มีอะไรผิด') {
                  //  print('สำเร็จ $a');
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: Container(
                              height: 400,
                              width: 300,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 300,
                                        width: 300,
                                        child: SingleChildScrollView(
                                            child: Center(child: Text(b!)))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Colors.blue,
                                          child: Text(
                                            'CANCLE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            await savePDF(FPDF);
                                            Directory documentDiresctory =
                                                await getApplicationDocumentsDirectory();
                                            final now = DateTime.now();
                                            String documentPath =
                                                documentDiresctory.path;
                                            namefile =
                                                "$documentPath/PDF/Label_${now.day}-${now.month}-${now.year}_$size.pdf";
                                            pdf = null;
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => PDFD(
                                            //               path: namefile,
                                            //             )));
                                          },
                                          color: Colors.blue,
                                          child: Text(
                                            'OK',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]))));
                } else {
                  await savePDF(FPDF);
                  Directory documentDiresctory =
                      await getApplicationDocumentsDirectory();
                  final now = DateTime.now();
                  String documentPath = documentDiresctory.path;
                  namefile =
                      "$documentPath/PDF/Label_${now.day}-${now.month}-${now.year}_$size.pdf";
                  pdf = null;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PDFD(
                  //               path: namefile,
                  //             )));
                }
              }
            
            },
            color: Colors.white,
            child: Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  Container sender2() {
    return Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: screenW * 0.85,
        height: screenH * 0.25,
        child: TextFormField(
          controller: _input1,
          maxLines: 12,
        ));
  }

  Container sender() {
    return Container(
      height: screenH * 0.08,
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Text(
          "รายละเอียดผู้ส่ง",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _chexcked,
        onChanged: (bool? value) {
          setState(() {
            _chexcked = value!;
          });
        },
      ),
    );
  }

  Container recipient2() {
    return Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: screenW * 0.75,
        height: screenH * 0.35,
        child: TextFormField(
          controller: _input,
          maxLines: 17,
        ));
  }

  Container recipient() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      height: screenH * 0.08,
      child: Text(
        'รายละเอียดผู้รับ',
        style: TextStyle(fontSize: 27, color: Colors.white),
      ),
    );
  }

  Container appber() {
    return Container(
      // margin: EdgeInsets.only(top: 20),
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
                              TextStyle(fontSize: 17, color: Color(0xff00aaf8)),
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

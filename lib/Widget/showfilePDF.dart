import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'showPDF.dart';

class ShowPDF extends StatefulWidget {
  @override
  State<ShowPDF> createState() => _ShowPDFState();
}

double screenW = 0.0, screenH = 0.0;
 var files;
 String? path;
  bool? l = true;
  bool? l1 = false;
  String? name;
  bool? l2 = false;
  File? file;
  double? h,w;

  
class _ShowPDFState extends State<ShowPDF> {
  Future showPDF() async {
    String size1 = '57x80';
    String size2 = '57x100';
    String size3 = '100x75';
    String size4 = '100x150';
    Directory documentDiresctory = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    String documentPath = documentDiresctory.path;
    l = false;
    setState(() {
      print(documentPath);
      files = Directory("${documentPath}/PDF").listSync();
      
      print(files.toString());
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    showPDF();
   
    super.initState();
  }


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
            SizedBox(height: 30.0),
            showpdf(),
          ],
        ),
      ),
    );
  }

   Container showpdf() {
    return Container(
            decoration: BoxDecoration(
         border: Border.all(color:  Color(0xff00aaf8), width: screenW*0.03) ),
            height: screenH * 0.7,
            width: screenW * 0.8,
          child: l!
          ? Center(
              child: CircularProgressIndicator(),
            )
          : files == null? Center(
              child: CircularProgressIndicator(),
            ) 
            :ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                String s = "${files.length}";
                String f = files[index].path;
                String namef = files[index].path.split('/').last;
                String namef1 = namef.split('.').first;
                String namef2 = namef1.split('_').last;
  
                if(namef2 == "57x80"){
                    h = 5.7;
                    w = 8.0;
                }
               else if(namef2 == "57x100"){
                    h = 5.7;
                    w = 10.0;
                }
               else if(namef2 == "100x75"){
                    h = 10.0;
                    w = 7.5;
                }
               else if(namef2 == "100x150"){
                    h = 10.0;
                    w = 15.0;
                }
                
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    selected: l2!,
                    onTap: () async{
                      var documentDiresctory = await getApplicationDocumentsDirectory();
                      setState(() {
                        file = File('${documentDiresctory.path}/PDF/${namef}');
                        path = '${documentDiresctory.path}/PDF/${namef}';
                        print("==========> : $path");
                        
                      });
                      
                      Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PrintDocuments(file:file,path:path,H: h,W: w,),),
                    );
                  
                    },
                    leading: Icon(Icons.picture_as_pdf),
                    title: Text(
                      '$namef',
                      style: TextStyle(
                          color: l2! ? Colors.black :  Color(0xff00aaf8), fontSize: 15),
                    ),
                    subtitle: Text(f,
                    overflow: TextOverflow.ellipsis,),
                  ),
                );
              }),
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

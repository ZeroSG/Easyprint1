// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class Showim extends StatefulWidget {
//   @override
//   State<Showim> createState() => _ShowimState();
// }

// // final netImg =decodeImage(File("${dirToSave.path}/myImage.jpg").readAsBytesSync());

// double screenW = 0.0, screenH = 0.0;
// var files;
// String path;
// bool l = true;
// bool l1 = false;
// String name;
// bool l2 = false;
// File file;

// class _ShowimState extends State<Showim> {
//   Future showPDF() async {
//     String size1 = '57x80';
//     String size2 = '57x100';
//     String size3 = '100x75';
//     String size4 = '100x150';
//     Directory documentDiresctory = await getApplicationDocumentsDirectory();
//     final now = DateTime.now();
//     String documentPath = documentDiresctory.path;
//     l = false;
//     setState(() {
//       print(documentPath);
//       files = Directory("${documentPath}/images").listSync();

//       print(files.toString());
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     showPDF();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenW = MediaQuery.of(context).size.width;
//     screenH = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             appber(),
//             SizedBox(height: 30.0),
//             showpdf(),
//             RaisedButton(
//               onPressed: () =>
//                   {Navigator.pushNamed(context, '/printdocuments')},
//               color: Colors.blue[200],
//               child: Text(
//                 'PREVIEW',
//                 style: TextStyle(color: Colors.blue, fontSize: 25),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Container showpdf() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.blue, width: screenW * 0.03)),
//       height: screenH * 0.7,
//       width: screenW * 0.8,
//       child: l
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: files.length,
//               itemBuilder: (context, index) {
//                 String s = "${files.length}";
//                 String f = files[index].path;
//                 String namef = files[index].path.split('/').last;
//                 return Card(
//                   elevation: 5,
//                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   child: ListTile(
//                     selected: l2,
//                     onTap: () async {
//                       showDialog(
//                           context: context,
//                           builder: (context) => Dialog(
//                               child: Container(
//                                   height: 400,
//                                   width: 500,
//                                   child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         border: Border.all(),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Image.file(files[index])))));
//                     },
//                     leading: Icon(Icons.picture_as_pdf),
//                     title: Text(
//                       '$namef',
//                       style: TextStyle(
//                           color: l2 ? Colors.black : Colors.blue, fontSize: 15),
//                     ),
//                     subtitle: Text(
//                       f,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 );
//               }),
//     );
//   }

//   Container appber() {
//     return Container(
//       margin: EdgeInsets.only(top: 18),
//       height: 80,
//       width: screenW * 1,
//       // color: Colors.black,
//       child: Row(
//         children: <Widget>[
//           Container(
//               margin: EdgeInsets.only(left: 2),
//               // height: screenH * 0.15,
//               // width: screenW * 0.08,
//               height: 70,
//               width: 70,
//               decoration:
//                   ShapeDecoration(color: Colors.blue, shape: CircleBorder())),
//           Container(
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(left: 5),
//                   child: Container(
//                     height: 45,
//                     // width: screenW * 0.8,
//                     // color: Colors.amber,
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         top: 17,
//                       ),
//                       child: Container(
//                         child: Text(
//                           'Easyprint',
//                           style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.blueAccent,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(right: 35),
//                   child: Container(
//                     height: 35,
//                     // width: screenW * 0.2,
//                     // color: Colors.green,
//                     child: Container(
//                       child: TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Log in >",
//                           style:
//                               TextStyle(fontSize: 17, color: Colors.blueAccent),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

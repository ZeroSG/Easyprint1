




import 'dart:io';
import 'dart:ui';

import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

import 'quantity.dart';
import 'showfilePDF.dart';

class PrintDocuments extends StatefulWidget {
  File? file;
  String? path;
  double? H;
  double? W;
  PrintDocuments({
     this.file,
    this.path,
    this.H,
    this.W,
  });

  @override
  State<PrintDocuments> createState() => _PrintDocumentsState();
}

double screenW = 0.0, screenH = 0.0;
class _PrintDocumentsState extends State<PrintDocuments> {
   var  document;
  bool? l = true;
  @override
  void initState() {
    super.initState();
    loadDocument();
    
  }

  loadDocument() async {
    try{
      // var s = await PDFDocument.fromAsset('images/17-11.pdf');
       var s = await PDFDocument.fromFile(widget.file!);

    setState(() {
      document = s;
      l = false;
    });
    }catch(e){
       print('e ===> ${e.toString()} ');
    }
  
  }


  late File? imgFile;

  imageFromPdfFile() async {
    String namef = path!.split('/').last;
    String namef1 = namef.split('.').first;
    String namef2 = namef1.split('_').last;

    PdfDocument doc = await PdfDocument.openFile(path);
    
    var pages = doc.pageCount;
    
    List<imglib.Image> images = [];

    for (int i = 1; i <= pages; i++) {
      var page = await doc.getPage(i);
      var imgPDF = await page.render(
        width: 285,
        height: 427
      );
      var img = await imgPDF.createImageDetached();
      var imgBytes = await img.toByteData(format: ImageByteFormat.png);
     var libImage = imglib.decodeImage(imgBytes!.buffer
          .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
      images.add(libImage!);
    }
    


    int totalHeight = 0;
    images.forEach((e) {
      totalHeight += e.height;
    });
    int totalWidth = 0;
    images.forEach((element) {
      totalWidth = totalWidth < element.width ? element.width : totalWidth;
    });
    final mergedImage = imglib.Image(totalWidth, totalHeight);
    int mergedHeight = 0;
    images.forEach((element) {
      imglib.copyInto(mergedImage, element,
          dstX: 0, dstY: mergedHeight, blend: false);
      mergedHeight += element.height;
    });

    // Save image as a file
     Directory documentDiresctory = await getApplicationDocumentsDirectory();
     String documentPath = documentDiresctory.path;
     
   Directory _appDocDirFolder = Directory("$documentPath/images/");
   var isThere = await _appDocDirFolder.exists();
     print(isThere ? 'exists' : 'non-existent');
     if(isThere != true){
         Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
         print('==================>เพิ่มสำเร็จ');
     }else{
       print('==================>มีอยู่เล้ว');
     }
     imgFile = new File('$documentPath/images/$namef2.jpg');
     new File(imgFile!.path).writeAsBytes(imglib.encodeJpg(mergedImage));
  

  }

//   void renderPdfImage() async {
//     // Initialize the renderer
//     var pdf = PdfImageRendererPdf(path: path);

//     // open the pdf document
//     await pdf.open();
//     var count = await pdf.getPageCount();
//     // open a page from the pdf document using the page index
//     // get the render size after the page is loaded
//     var img;
//     try{
//    for (var i = 0; i < count; i++) {
//      await pdf.openPage(pageIndex: i);
//      var size = await pdf.getPageSize(pageIndex: 0);
//    print(i);
//     img = await pdf.renderPage(
//           pageIndex: 0,
//           x: 0,
//           y: 0,
//           width: size.width, // you can pass a custom size here to crop the image
//           height: size.height, // you can pass a custom size here to crop the image
//           scale: 1.0, // increase the scale for better quality (e.g. for zooming)
//           background: Colors.white,
//         );
//         await pdf.closePage(pageIndex: 0);
//         print(img);
//    }
//    await pdf.closePage(pageIndex: 0);
//    }catch(e){
// print('e ===> ${e.toString()} ');
//   }
//     // close the page again

//     // use setState to update the renderer
//     setState(() {
//       image = img;
//     });

//   }

  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appber(),
            SizedBox(height: 30.0),
            showpdf(),
            RaisedButton(
              onPressed: () async {
                await  imageFromPdfFile();
                print(imgFile!.path.toString());
                Navigator.pushNamed(context, '/quantity');
                 Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Quantity(imgFile:imgFile),),
                    );



                          //            showDialog(
                          // context: context,
                          // builder: (context) => Dialog(
                          //     child: Container(
                          //         height: 400,
                          //         width: 500,
                          //         child: DecoratedBox(
                          //             decoration: BoxDecoration(
                          //               color: Colors.black,
                          //               border: Border.all(),
                          //               borderRadius: BorderRadius.circular(20),
                          //             ),
                          //             child: Image.file(files[imgFile])))));
              },
              color: Colors.blue[200],
              child: Text(
                'PRINT',
                style: TextStyle(color: Colors.blue, fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  // _printPdf(String A,double b,double c) async {
  // try{
  //   print("$b=======>$c");
  //    Directory documentDiresctory = await getApplicationDocumentsDirectory();
  //    String documentPath = documentDiresctory.path;
  //   var pdf = await  rootBundle.load(A);
  //   // ByteData pdf = await rootBundle.load(A);
  //   await Printing.layoutPdf(format: PDFS.PdfPageFormat(b * PDFS.PdfPageFormat.cm, c * PDFS.PdfPageFormat.cm),
  //     onLayout: (_) => pdf.buffer.asUint8List());
  //     return pdf;
  // }catch(e){
  //   print('e ===> ${e.toString()} ');
  // }
  // }

  Container showpdf() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: screenW * 0.03)),
        height: screenH * 0.7,
        width: screenW * 0.8,
        child: l!
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(
                        document: document,
                        zoomSteps: 10,
                        showPicker: false,
              )
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
                  ShapeDecoration(color: Colors.blue, shape: CircleBorder())),
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
                              color: Colors.blueAccent,
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
                              TextStyle(fontSize: 17, color: Colors.blueAccent),
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

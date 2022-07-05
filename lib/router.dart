
import 'package:flutter/material.dart';

import 'Widget/bluetooth.dart';
import 'Widget/index.dart';
import 'Widget/link.dart';
import 'Widget/inputPDF.dart';
import 'Widget/size.dart';
import 'Widget/print.dart';
import 'Widget/showPDF.dart';
import 'Widget/quantity.dart';
import 'Widget/showfilePDF.dart';
import 'main.dart';




final Map<String, WidgetBuilder> routes = {
  '/index': (BuildContext context) => Index(),
  '/newdocument': (BuildContext context) => newDocumentPDF(),
  '/newdocumentEXcel': (BuildContext context) => newDocumentEXCEL(),
  '/print': (BuildContext context) => print1(),
 '/showPDF': (BuildContext context) => ShowPDF(),
 '/printdocuments': (BuildContext context) => PrintDocuments(file: null,),
 '/quantity': (BuildContext context) => Quantity(),
  '/link': (BuildContext context) => Link1(),
  '/home': (BuildContext context) => home(),
   '/file': (BuildContext context) => file1(),
   '/bluetooth': (BuildContext context) => Bluetooth1(),
  //  '/showim': (BuildContext context) => Showim(),
};

newDocumentEXCEL() {
}
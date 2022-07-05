import 'dart:io';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'size.dart';

class newDocumentEXCEL extends StatefulWidget {
  String? EXcel, PopUp;
  newDocumentEXCEL({Key? key, this.EXcel, this.PopUp}) : super(key: key);
  @override
  State<newDocumentEXCEL> createState() => _newDocumentEXCELState();
}
var excel1 = "excel";
var excel = null;
bool? _chexcked = false;
double? screenW = 0.0, screenH = 0.0;
var str = '';
String? fileexcel;
String? a, b;
Future saveExcelKerry() async {
  excel = Excel.createExcel();
  var str = _input.text;
  var splitted = str.split("//");
  Sheet sheetObject = excel['Sheet1'];
  CellStyle KerryStyle = CellStyle(backgroundColorHex: "#bfbfbf");
  var Kerry1 = sheetObject.cell(CellIndex.indexByString("A1"));
  var Kerry2 = sheetObject.cell(CellIndex.indexByString("B1"));
  var Kerry3 = sheetObject.cell(CellIndex.indexByString("C1"));
  var Kerry4 = sheetObject.cell(CellIndex.indexByString("D1"));
  var Kerry5 = sheetObject.cell(CellIndex.indexByString("E1"));
  var Kerry6 = sheetObject.cell(CellIndex.indexByString("F1"));
  var Kerry7 = sheetObject.cell(CellIndex.indexByString("G1"));
  var Kerry8 = sheetObject.cell(CellIndex.indexByString("H1"));
  var Kerry9 = sheetObject.cell(CellIndex.indexByString("I1"));
  var Kerry10 = sheetObject.cell(CellIndex.indexByString("J1"));
  var Kerry11 = sheetObject.cell(CellIndex.indexByString("K1"));
  var Kerry12 = sheetObject.cell(CellIndex.indexByString("L1"));
  Kerry1.value = "No";
  Kerry2.value = "Recipient Name";
  Kerry3.value = "Mobile No.";
  Kerry4.value = "Email";
  Kerry5.value = "Address#1";
  Kerry6.value = "Address#2";
  Kerry7.value = "Zip Code";
  Kerry8.value = "COD Amt(Baht)";
  Kerry9.value = "Remark";
  Kerry10.value = "Ref #1";
  Kerry11.value = "Ref #2";
  Kerry12.value = "Sender Ref";

  Kerry1.cellStyle = KerryStyle;
  Kerry2.cellStyle = KerryStyle;
  Kerry3.cellStyle = KerryStyle;
  Kerry4.cellStyle = KerryStyle;
  Kerry5.cellStyle = KerryStyle;
  Kerry6.cellStyle = KerryStyle;
  Kerry7.cellStyle = KerryStyle;
  Kerry8.cellStyle = KerryStyle;
  Kerry9.cellStyle = KerryStyle;
  Kerry10.cellStyle = KerryStyle;
  Kerry11.cellStyle = KerryStyle;
  Kerry12.cellStyle = KerryStyle;
  for (int i = 0; i < splitted.length; i++) {
    var splitted1 = splitted[i].split("#");
    var Kerry_7 = sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
    var Kerry_8 = sheetObject.cell(CellIndex.indexByString("I${i + 2}"));
    Kerry_7.value = '0';
    Kerry_8.value = '-';
    try {
      var Kerry_1 = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
      var Kerry_2 = sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
      var Kerry_3 = sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
      var Kerry_4 = sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
      var Kerry_5 = sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
      var Kerry_6 = sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
      Kerry_1.value = '${i+1}';
      Kerry_2.value = splitted1[0];
      Kerry_3.value = splitted1[1];
      Kerry_4.value = splitted1[2];
      Kerry_5.value = splitted1[3];
      Kerry_6.value = splitted1[4];
      Kerry_7.value = splitted1[5];
      Kerry_8.value = splitted1[6];
      print(splitted1);
    } catch (e) {
      print('e ===> ${e.toString()} ');
      a = '${e.toString()}';
      b = '${e.toString()}';
      if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..4: 5') {
        a = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
        b = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
      }
      if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..5: 6') {
        a = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
        b = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
      }
    }
  }
}

Future selectedFlash() async {
  excel = Excel.createExcel();
  var str = _input.text;
  var splitted = str.split("//");
  Sheet sheetObject = excel['Sheet1'];
  CellStyle FlashStyle = CellStyle(backgroundColorHex: "#FFFF00");
  var Flash1 = sheetObject.cell(CellIndex.indexByString("A1"));
  var Flash2 = sheetObject.cell(CellIndex.indexByString("B1"));
  Flash2.cellStyle = FlashStyle;
  var Flash3 = sheetObject.cell(CellIndex.indexByString("C1"));
  Flash3.cellStyle = FlashStyle;
  var Flash4 = sheetObject.cell(CellIndex.indexByString("D1"));
  Flash4.cellStyle = FlashStyle;
  var Flash5 = sheetObject.cell(CellIndex.indexByString("E1"));
  Flash5.cellStyle = FlashStyle;
  var Flash6 = sheetObject.cell(CellIndex.indexByString("F1"));
  var Flash7 = sheetObject.cell(CellIndex.indexByString("G1"));
  Flash7.cellStyle = FlashStyle;
  var Flash8 = sheetObject.cell(CellIndex.indexByString("H1"));
  var Flash9 = sheetObject.cell(CellIndex.indexByString("I1"));
  Flash9.cellStyle = FlashStyle;
  var Flash10 = sheetObject.cell(CellIndex.indexByString("J1"));
  var Flash11 = sheetObject.cell(CellIndex.indexByString("K1"));
  var Flash12 = sheetObject.cell(CellIndex.indexByString("L1"));
  var Flash13 = sheetObject.cell(CellIndex.indexByString("M1"));
  var Flash14 = sheetObject.cell(CellIndex.indexByString("N1"));
  var Flash15 = sheetObject.cell(CellIndex.indexByString("O1"));
  var Flash16 = sheetObject.cell(CellIndex.indexByString("P1"));
  var Flash17 = sheetObject.cell(CellIndex.indexByString("Q1"));
  var Flash18 = sheetObject.cell(CellIndex.indexByString("R1"));
  Flash18.cellStyle = FlashStyle;
  var Flash19 = sheetObject.cell(CellIndex.indexByString("S1"));
  Flash1.value = "เลขออเดอร์ของลูกค้า";
  Flash2.value = "ชื่อผู้รับ";
  Flash3.value = "ที่อยู่";
  Flash4.value = "รหัสไปรษณีย์";
  Flash5.value = "เบอร์โทรศัพท์";
  Flash6.value = "เบอร์โทรศัพท์";
  Flash7.value = "ยอดเรียกเก็บ";
  Flash8.value = "ประเภทสินค้า";
  Flash9.value = "น้ำหนัก";
  Flash10.value = "ยาว";
  Flash11.value = "กว้าง";
  Flash12.value = "สูง";
  Flash13.value = "คุ้มครองพัสดุตีกลับ";
  Flash14.value = "คุ้มครองพัสดุ";
  Flash15.value = "มูลค้าสินค้าที่ระบุโดยลูกค้า";
  Flash16.value = "คุ้มครองบรรจุภัณฑ์ภายนอกเสียหาย";
  Flash17.value = "ประเภทสินค้า";
  Flash18.value = "หมายเหตุ1";
  Flash19.value = "หมายเหตุ2";
  
  for (int i = 0; i < splitted.length; i++) {
    var splitted1 = splitted[i].split("#");
     var Flash_5 = sheetObject.cell(CellIndex.indexByString("I${i + 2}"));
     var Flash_6 = sheetObject.cell(CellIndex.indexByString("R${i + 2}"));
      Flash_5.value = '0';
      Flash_6.value = "-";
    try {
      var Flash_1 = sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
      var Flash_2 = sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
      var Flash_3 = sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
      var Flash_4 = sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
      var Flash_7 = sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
      Flash_7.value = "$PopUp";
      Flash_1.value = splitted1[0];
      Flash_2.value = splitted1[1];
      Flash_3.value = splitted1[2];
      Flash_4.value = splitted1[3];
      Flash_5.value = splitted1[4];
      Flash_6.value = splitted1[5];
      print(splitted1);
    } catch (e) {
      print('e ===> ${e.toString()} ');
      a = '${e.toString()}';
      b = '${e.toString()}';
        if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..3: 4') {
        a = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
        b = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
      }
      if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..4: 5') {
        a = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
        b = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
      }
    }
  }
}

Future saveExcelJ_T() async {
  excel = Excel.createExcel();
  var str = _input.text;
  var splitted = str.split("//");
  Sheet sheetObject = excel['Sheet1'];
  CellStyle J_TStyle = CellStyle(backgroundColorHex: "#bdd7ee");
  var J_T1 = sheetObject.cell(CellIndex.indexByString("A1"));
  var J_T2 = sheetObject.cell(CellIndex.indexByString("B1"));
  var J_T3 =  sheetObject.cell(CellIndex.indexByString("C1"));
  var J_T4 = sheetObject.cell(CellIndex.indexByString("D1"));
  var J_T5 = sheetObject.cell(CellIndex.indexByString("E1"));
  var J_T6 =  sheetObject.cell(CellIndex.indexByString("F1"));
  var J_T7 = sheetObject.cell(CellIndex.indexByString("G1"));
  var J_T8 =  sheetObject.cell(CellIndex.indexByString("H1"));
  var J_T9 = sheetObject.cell(CellIndex.indexByString("I1"));
  var J_T10 = sheetObject.cell(CellIndex.indexByString("J1"));
  var J_T11 = sheetObject.cell(CellIndex.indexByString("K1"));
  var J_T12 = sheetObject.cell(CellIndex.indexByString("L1"));
  var J_T13 = sheetObject.cell(CellIndex.indexByString("M1"));
  var J_T14 = sheetObject.cell(CellIndex.indexByString("N1"));
  var J_T15 = sheetObject.cell(CellIndex.indexByString("O1"));
  var J_T16 = sheetObject.cell(CellIndex.indexByString("P1"));
     J_T1.value ="น้ำหนักพัสดุ\n(กิโลกรัม)";
     J_T2.value ="ชื่อสกุลผู้รับ";
     J_T3.value ="โทรศัพท์ผู้รับ";
     J_T4.value ="จังหวัดผู้รับ";
     J_T5.value ="เขตอำเภอผู้รับ";
     J_T6.value ="ตำบลปลายทาง";
     J_T7.value ="รหัสไปรษณีย์ปลายทาง";
     J_T8.value ="ที่อยู่ผู้รับ";
     J_T9.value ="รายละเอียดพัสดุ";
     J_T10.value ="มูลค่าพัสดุโดยประเมิน";
     J_T11.value ="หมายเหตุ";
     J_T12.value ="จำนวนเงินที่ชำระปลายทาง\n(COD))";
     J_T13.value ="กว้าง(ซม.)";
     J_T14.value ="ยาว(ซม.)";
     J_T15.value ="สูง(ซม.)";
     J_T16.value ="ค่าบรรจุภัณฑ์";

  J_T1.cellStyle = J_TStyle;   
  J_T2.cellStyle = J_TStyle;   
  J_T3.cellStyle = J_TStyle;   
  J_T4.cellStyle = J_TStyle;   
  J_T5.cellStyle = J_TStyle;   
  J_T6.cellStyle = J_TStyle;   
  J_T7.cellStyle = J_TStyle;   
  J_T8.cellStyle = J_TStyle;   
  J_T9.cellStyle = J_TStyle;   
  J_T10.cellStyle = J_TStyle;   
  J_T11.cellStyle = J_TStyle;   
  J_T12.cellStyle = J_TStyle;   
  J_T13.cellStyle = J_TStyle;   
  J_T14.cellStyle = J_TStyle;   
  J_T15.cellStyle = J_TStyle;   
  J_T16.cellStyle = J_TStyle;   
  for (int i = 0; i < splitted.length; i++) {
    var splitted1 = splitted[i].split("#");
     var J_T_10 = sheetObject.cell(CellIndex.indexByString("K${i + 2}"));
     var J_T_11 = sheetObject.cell(CellIndex.indexByString("L${i + 2}"));
     J_T_10.value = '-';
     J_T_11.value = '0';
    try {
      var J_T_1 = sheetObject.cell(CellIndex.indexByString("A${i + 2}")).value =
          "$PopUp";
      var J_T_2 = sheetObject.cell(CellIndex.indexByString("B${i + 2}")).value =
          splitted1[0];
      var J_T_3 = sheetObject.cell(CellIndex.indexByString("C${i + 2}")).value =
          splitted1[1];
      var J_T_4 = sheetObject.cell(CellIndex.indexByString("D${i + 2}")).value =
          splitted1[2];
      var J_T_5 = sheetObject.cell(CellIndex.indexByString("E${i + 2}")).value =
          splitted1[3];
      var J_T_6 = sheetObject.cell(CellIndex.indexByString("F${i + 2}")).value =
          splitted1[4];
      var J_T_7 = sheetObject.cell(CellIndex.indexByString("G${i + 2}")).value =
          splitted1[5];
      var J_T_8 = sheetObject.cell(CellIndex.indexByString("H${i + 2}")).value =
          splitted1[6];
      var J_T_9 = sheetObject.cell(CellIndex.indexByString("I${i + 2}")).value =
          splitted1[7];
          J_T_10.value = splitted1[8];
          J_T_11.value = splitted1[9];
      print(splitted1);
    } catch (e) {
      print('e ===> ${e.toString()} ');
      a = '${e.toString()}';
      b = '${e.toString()}';
      if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..8: 9') {
        a = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
        b = 'กำหนดค่าCODหรือไม่ ถ้าไม่ ค่าเป็น 0 ';
      }
      if (e.toString() ==
          'RangeError (length): Invalid value: Not in inclusive range 0..7: 8') {
        a = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
        b = 'กำหนดค่าRemarkหรือไม่ ถ้าไม่ ค่าเป็น - ';
      }
    }
  }
}

final TextEditingController _input = TextEditingController();
final TextEditingController _input1 = TextEditingController();

class _newDocumentEXCELState extends State<newDocumentEXCEL> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 18),
        width: screenW! * 1,
        height: screenH! * 1,
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
      width: screenW! * 0.85,
      height: screenH! * 0.1,
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
                if (EXcel == 'Flash') {
                  setState(() {
                    a = 'ไม่มีอะไรผิด';
                  });
                  await selectedFlash();
                  if (a != 'ไม่มีอะไรผิด') {
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
                                    Center(child: Text(a!)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/newdocumentEXcel');
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
                                            await SetExcel(excel1);
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
                                  ],
                                ),
                              ),
                            ));
                  } else {
                    await SetExcel(excel1);
                  }
                }
                if (EXcel == 'Kerry') {
                  setState(() {
                    a = 'ไม่มีอะไรผิด';
                  });
                  await saveExcelKerry();
                  if (a != 'ไม่มีอะไรผิด') {
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
                                    Center(child: Text(a!)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/newdocumentEXcel');
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
                                            await SetExcel(excel1);
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
                                  ],
                                ),
                              ),
                            ));
                  } else {
                    await SetExcel(excel1);
                  }
                }
                if (EXcel == 'J_&_T') {
                  setState(() {
                    a = 'ไม่มีอะไรผิด';
                  });
                  await saveExcelJ_T();
                  if (a != 'ไม่มีอะไรผิด') {
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
                                    Center(child: Text(a!)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/newdocumentEXcel');
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
                                            await SetExcel(excel1);
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
                                  ],
                                ),
                              ),
                            ));
                  } else {
                    await SetExcel(excel1);
                  }
                }
              } else {}
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

  Future SetExcel(String folderName) async {
    final now = DateTime.now();
    Directory documentDiresctory = await getApplicationDocumentsDirectory();
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
    //  print('==================>$isThere');
    File file = File(
        "$documentPath/$folderName/Label_${now.day}-${now.month}-${now.year}_$EXcel.xlsx");
    file.writeAsBytesSync(await excel.encode());


        fileexcel =
        "$documentPath/$folderName/Label_${now.day}-${now.month}-${now.year}_$EXcel.xlsx";

    OpenFile.open(fileexcel);

   
  }

  Container sender2() {
    return Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: screenW! * 0.85,
        height: screenH! * 0.25,
        child: TextFormField(
          controller: _input1,
          maxLines: 12,
        ));
  }

  Container sender() {
    return Container(
      height: screenH! * 0.08,
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
            _chexcked = value;
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
        width: screenW! * 0.75,
        height: screenH! * 0.35,
        child: TextFormField(
          controller: _input,
          maxLines: 17,
        ));
  }

  Container recipient() {
    return Container(
      margin: EdgeInsets.only(top: 18),
      height: screenH! * 0.08,
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
      width: screenW! * 1,
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

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:pdf/pdf.dart';

import 'inputEXCEL.dart';
import 'inputPDF.dart';

class file1 extends StatefulWidget {
  @override
  State<file1> createState() => _file1State();
}

TextEditingController pop_up = TextEditingController();

bool _Filemini = false;
bool _Filemin = false;
bool _Filemax = false;
bool _Filemax2 = false;
bool _Kerry = false;
bool _Flash = false;
bool _J_T = false;
 final FormKey = GlobalKey<FormState>();
double screenW = 0.0, screenH = 0.0;
PdfPageFormat? PDF;
String? size = '';
double? w, w1, h;
String? EXcel;
String? PopUp = '1';

class _file1State extends State<file1> {
  @override
  Widget build(BuildContext context) {
    screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 18),
        color: Color(0xff00aaf8),
        child: Column(
          children: <Widget>[
            appber(),
            Filemini(),
            Filemin(),
            Filemax(),
            Filemax2(),
            Kerry(),
            Flash(),
            JT(),
            OK(context)
          ],
        ),
      ),
    );
  }

  RaisedButton OK(BuildContext context) {
    return RaisedButton(
      onPressed: () => {
        if ((_Kerry || _Flash || _J_T) == true){
        showDialog(
            context: context,
            builder: (context) => Dialog(
                    child: Container(
                  height: 200,
                  width: 300,
                  child: Form(
                    key: FormKey,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 25),
                              //  height: 75,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(   
                                controller: pop_up,
                                validator: RequiredValidator(errorText: "??????????????????????????? ?????????????????????"),
                                decoration: InputDecoration(
                                  labelText: '????????????????????? : ',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              )),
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.blue, fontSize: 25),
                          ),
                          onPressed: () {
                            if (FormKey.currentState!.validate()) {
                               PopUp = pop_up.text;
                            print(PopUp);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    newDocumentEXCEL(EXcel: EXcel!,PopUp:PopUp!),
                              ),
                            );
                            FormKey.currentState!.reset();
                            }
                            
                            
                          },
                        ),
                      ],
                    ),
                  ),
                ))),
        },
        if ((_Filemini || _Filemin || _Filemax || _Filemax2) == true)
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => newDocumentPDF(
                  PDF: PDF.toString(),
                  w: w!,
                  w1: w1!,
                  h: h!,
                ),
              ),
            ),
          },
      },
      color: Colors.white,
      child: Text(
        'OK',
        style: TextStyle(color: Colors.blue, fontSize: 25),
      ),
    );
  }

  Container Filemini() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "??????????????? PDF 57*80",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\n1???????????? ????????????????????? 12?????????????????? ?????????????????? 26??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\n????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF57_80_2.png')),
                              Center(
                                  child: Text(
                                "\n1???????????? ?????????????????? ????????????????????? 12?????????????????? ?????????????????? 16?????? ?????????????????? ????????????????????? 6?????????????????? ?????????????????? 14??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\?????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/inputPDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output1PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output2PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\???????????????????????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/input2PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output3PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output4PDF57_80.png')),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Filemini,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = value!;
            _Filemin = false;
            _Filemax = false;
            _Filemax2 = false;
            _Kerry = false;
            _Flash = false;
            _J_T = false;
            PDF = PdfPageFormat(5.7 * PdfPageFormat.cm, 8.0 * PdfPageFormat.cm);
            size = '57x80';
            w = 90;
            w1 = 60;
            h = 70;
          });
        },
      ),
    );
  }

  Container Filemin() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "??????????????? PDF 57*100",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF57_100.png')),
                              Center(
                                  child: Text(
                                "\n1???????????? ????????????????????? 16?????????????????? ?????????????????? 26??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\n????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF57_100_2.png')),
                              Center(
                                  child: Text(
                                "\n1????????????  ??????????????????  ????????????????????? 15?????????????????? ?????????????????? 15?????? ?????????????????? ????????????????????? 10?????????????????? ?????????????????? 15??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\?????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/inputPDF57_100.png')),
                              Center(
                                  child: Text(
                                "\????????????1\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output1PDF57_100.png')),
                              Center(
                                  child: Text(
                                "\????????????2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output2PDF57_100.png')),
                              Center(
                                  child: Text(
                                "\???????????????????????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/input2PDF57_100.png')),
                              Center(
                                  child: Text(
                                "\????????????1\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output3PDF57_100.png')),
                              Center(
                                  child: Text(
                                "\????????????2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output4PDF57_100.png')),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Filemin,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = value!;
            _Filemax = false;
            _Filemax2 = false;
            _Kerry = false;
            _Flash = false;
            _J_T = false;
            PDF =
                PdfPageFormat(5.7 * PdfPageFormat.cm, 10.0 * PdfPageFormat.cm);
            size = '57x100';
            w = 85;
            w1 = 65;
            h = 100;
          });
        },
      ),
    );
  }

  Container Filemax() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "??????????????? PDF 100*75",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF100_75.png')),
                              Center(
                                  child: Text(
                                "\n1???????????? ????????????????????? 11?????????????????? ?????????????????? 48??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\n????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF100_75_2.png')),
                              Center(
                                  child: Text(
                                "\n1????????????  ??????????????????  ????????????????????? 11?????????????????? ?????????????????? 26?????? ?????????????????? ????????????????????? 6?????????????????? ?????????????????? 33??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\?????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/inputPDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1-2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output1PDF100_75.png')),
                              Center(
                                  child: Text(
                                "\???????????????????????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/input2PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1-2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output2PDF100_75.png')),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Filemax,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = false;
            _Filemax = value!;
            _Filemax2 = false;
            _Kerry = false;
            _Flash = false;
            _J_T = false;
            PDF =
                PdfPageFormat(10.0 * PdfPageFormat.cm, 7.5 * PdfPageFormat.cm);
            size = '100x75';
            w = 145;
            w1 = 125;
            h = 60;
          });
        },
      ),
    );
  }

  Container Filemax2() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "??????????????? PDF 100*150",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/PDF100_150.png')),
                              Center(
                                  child: Text(
                                "\n1???????????? ????????????????????? 24?????????????????? ?????????????????? 48??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\n????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/PDF100_150_2.png')),
                              Center(
                                  child: Text(
                                "\n1????????????  ??????????????????  ????????????????????? 24?????????????????? ?????????????????? 31?????? ?????????????????? ????????????????????? 10?????????????????? ?????????????????? 26??????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\?????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/inputPDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1-2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output1PDF100_150.png')),
                              Center(
                                  child: Text(
                                "\???????????????????????????????????????????????????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child:
                                      Image.asset('images/input2PDF57_80.png')),
                              Center(
                                  child: Text(
                                "\????????????1-2\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset(
                                      'images/output2PDF100_150.png')),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Filemax2,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = false;
            _Filemax = false;
            _Filemax2 = value!;
            _Kerry = false;
            _Flash = false;
            _J_T = false;
            PDF =
                PdfPageFormat(10.0 * PdfPageFormat.cm, 15.0 * PdfPageFormat.cm);
            size = '100x150';
            w = 170;
            w1 = 100;
            h = 100;
          });
        },
      ),
    );
  }

  Container Kerry() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Kerry",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Center(
                                  child: Text(
                                "\ninput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/Kerry_input.jpg')),
                              Center(
                                  child: Text(
                                "\n?????????????????????????????????????????? ????????????\n 1.??????????????????????????????\n 2.?????????????????????????????????\n 3.????????????????????? 1\n 4.????????????????????? 2\n 5.????????????????????????????????????\n 6.COD\n 7.Remark\n ?????????????????????????????????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\noutput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 200,
                                  width: 100,
                                  child:
                                      Image.asset('images/Kerry_output.jpg')),
                              Center(
                                  child: Text(
                                "??????????????????????????????excel????????????????????????????????????????????????????????? excel ",
                                style: TextStyle(fontSize: 18),
                              )),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Kerry,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = false;
            _Filemax = false;
            _Filemax2 = false;
            _Kerry = value!;
            _Flash = false;
            _J_T = false;
            EXcel = 'Kerry';
          });
        },
      ),
    );
  }

  Container Flash() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Flash",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Center(
                                  child: Text(
                                "\ninput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/Flash_input.jpg')),
                              Center(
                                  child: Text(
                                "\n ?????????????????????????????????????????? ????????????\n 1.??????????????????????????????\n 2.?????????????????????\n 3.????????????????????????????????????\n 4.???????????????????????????????????????\n 5.?????????????????????\n 6.?????????????????????????????????\n 7.????????????????????????\n ?????????????????????????????????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\noutput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 200,
                                  width: 100,
                                  child:
                                      Image.asset('images/Flash_output.jpg')),
                              Center(
                                  child: Text(
                                "??????????????????????????????excel????????????????????????????????????????????????????????? excel ",
                                style: TextStyle(fontSize: 18),
                              )),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _Flash,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = false;
            _Filemax = false;
            _Filemax2 = false;
            _Kerry = false;
            _Flash = value!;
            _J_T = false;
            EXcel = 'Flash';
          });
        },
      ),
    );
  }

  Container JT() {
    return Container(
      child: CheckboxListTile(
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Row(
          children: [
            Text(
              "J & T",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                            child: Container(
                          height: 400,
                          width: 500,
                          child: ListView(
                            children: [
                              Center(
                                  child: Text(
                                "\n??????????????????\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Center(
                                  child: Text(
                                "\ninput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/JT_input1.jpg')),
                              Container(
                                  height: 400,
                                  width: 100,
                                  child: Image.asset('images/JT_input.jpg')),
                              Center(
                                  child: Text(
                                "\n ?????????????????????????????????????????? ????????????\n 1.??????????????????????????????????????????\n 2.??????????????????????????????????????????\n 3.???????????????????????????????????????\n 4.??????????????????????????????????????????\n 5.?????????????????????????????????\n 6.?????????????????????????????????????????????????????????\n 7.???????????????????????????????????????\n 8.?????????????????????????????????????????????\n  9.?????????????????????????????????????????????????????????????????????(COD)\n 10.????????????????????????\n ?????????????????????????????????",
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: Text(
                                "\noutput\n",
                                style: TextStyle(fontSize: 20),
                              )),
                              Container(
                                  height: 200,
                                  width: 100,
                                  child: Image.asset('images/JT_output.jpg')),
                              Center(
                                  child: Text(
                                "??????????????????????????????excel????????????????????????????????????????????????????????? excel ",
                                style: TextStyle(fontSize: 18),
                              )),
                            ],
                          ),
                        )));
              },
              child: Text(
                "#",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _J_T,
        onChanged: (bool? value) {
          setState(() {
            _Filemini = false;
            _Filemin = false;
            _Filemax = false;
            _Filemax2 = false;
            _Kerry = false;
            _Flash = false;
            _J_T = value!;
            EXcel = 'J_&_T';
          });
        },
      ),
    );
  }

  Container appber() {
    return Container(
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

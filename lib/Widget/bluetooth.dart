import 'dart:convert';
import 'dart:io';


import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/services.dart';



class Bluetooth1 extends StatefulWidget {
  File? imgFile;
  Bluetooth1({ Key? key,this.imgFile }) : super(key: key);

  @override
  State<Bluetooth1> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth1> {
   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => {initPrinter()});
  }
  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen(
      (val) {
        if (!mounted) return;
        setState(() => {_devices = val});
        if (_devices.isEmpty)
          setState(() {
            _devicesMsg = "No Devices";
          });
      },
    );
  }
  double screenW = 0.0, screenH = 0.0;
  @override
  Widget build(BuildContext context) {
        screenW = MediaQuery.of(context).size.width;
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          appber(),
          Container(
            height: screenH *0.5,
            child: _devices.isEmpty
                ? Center(
                    child: Text(_devicesMsg),
                  )
                   : _devices==null?  Center(
                    child: Text(_devicesMsg),
                  )
                   : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        leading: Icon(Icons.print),
                        title: Text(_devices[i].name!),
                        subtitle: Text(_devices[i].address!),
                        onTap: () {
                          _startPrint(_devices[i]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
    Future<void> _startPrint(BluetoothDevice device) async {
      
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [];
      List<int> imageBytes = widget.imgFile!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      // ByteData data = await rootBundle.load("assets/images/guide3.png");
      //  List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // String base64Image = base64Encode(imageBytes);
      
 
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Grocery App",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
      );
      // list.add(
      //   LineText(
      //     type: LineText.TYPE_IMAGE,
      //     content: base64Image,
      //     // weight: 2,
      //     // width: 2,
      //     // height: 2,
      //     align: LineText.ALIGN_CENTER,
      //     linefeed: 1,
      //   ),
      // );

      
      }
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

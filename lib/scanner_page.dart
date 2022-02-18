import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import 'package:virtual_emp/user_model.dart';

class ScannerPage extends StatefulWidget {
  final String attendanceStatus;
  const ScannerPage({Key? key, required this.attendanceStatus})
      : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final database = FirebaseDatabase.instance.ref();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      "Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code} ")
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    //final attendance = database.child('attendance');
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    var timeformatter = DateFormat('yyyy-MM-dd - kk:mm');
    String formattedTime = timeformatter.format(now);

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        try {
          if (widget.attendanceStatus == 'Time in') {
            database
                .child('attendance')
                .child(formattedDate)
                .child(loggedInUser.uid.toString())
                .set({
              "empId": loggedInUser.uid,
              "lastName": loggedInUser.lastName,
              "firstName": loggedInUser.firstName,
              "timeIn": formattedTime,
              "timeOut": '-'
            });
          } else if (widget.attendanceStatus == 'Time out') {
            database
                .child('attendance')
                .child(formattedDate)
                .child(loggedInUser.uid.toString())
                .update({
              "timeOut": formattedTime
            });
          }
        } catch (e) {
          print(e);
        }
        // print(loggedInUser.firstName);
        // print(loggedInUser.lastName);
        // print(loggedInUser.uid);
        // print(widget.attendanceStatus);
        //print(loggedInUser.lastName);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import 'package:virtual_emp/model/user_model.dart';

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

 

  final String _collection = 'collectionName';

  // final StreamBuilder<QuerySnapshot> qr = FirebaseFirestore.instance
  //     .collection('qr')
  //     .snapshots() as StreamBuilder<QuerySnapshot<Object?>>;

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
                  ? const Text(
                    'Attendance Successfully recorded!')
                      //"Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code} ")
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    //final attendance = database.child('attendance');
    var collection = FirebaseFirestore.instance.collection('qr');
    var docSnapshot = await collection.doc('employeeQr').get();
    var qrVal;
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      qrVal = data['qrValue'];
    }

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    //FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var timeformatter = DateFormat('kk:mm');
    String formattedTime = timeformatter.format(now);

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        try {
          if (result!.code.toString() == qrVal) {
            if (widget.attendanceStatus == 'Time in') {
                CollectionReference attendance = FirebaseFirestore.instance.collection(formattedDate);
                attendance.doc(loggedInUser.uid)
                  .set({
                    "empId": loggedInUser.uid,
                    "firstName":loggedInUser.firstName,
                    "lastName" : loggedInUser.lastName,
                    "timeIn" : formattedTime,
                    "timeOut" : "-",
                  });
            } else if (widget.attendanceStatus == 'Time out') {
              CollectionReference attendance = FirebaseFirestore.instance.collection(formattedDate);
                attendance.doc(loggedInUser.uid).update({"timeOut": formattedTime});
            }
          } else {
            Fluttertoast.showToast(msg: "Invalid Qr code!",toastLength: Toast.LENGTH_SHORT);
            result = null;
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  Future<void> _showNoQrDialog() async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This Qr does not exist in the database'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

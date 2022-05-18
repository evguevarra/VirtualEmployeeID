import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import 'package:virtual_emp/model/user_model.dart';
import 'package:virtual_emp/views/attendance_page.dart';

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

  String timeInVal = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  DateTime ntpTime = DateTime.now();

  late bool isQrValid;

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
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    _loadNtpTime();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _loadNtpTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Scanner"),
        backgroundColor: Colors.red,
      ),
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
                  ? const Text('Scanning!')
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

    var timeformatter = DateFormat('kk:mm');
    String formattedTime = timeformatter.format(ntpTime);

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        try {
          if (result!.code.toString() == qrVal) {
            if (widget.attendanceStatus == 'Time in') {
              CollectionReference attendance =
                  FirebaseFirestore.instance.collection(formattedDate);

              String status = '-';
              DateTime startShiftTime =
                  DateTime.parse(formattedDate + " 08:00:00");

              if (now.isAfter(startShiftTime)) {
                status = 'Late';
              } else if (now.isBefore(startShiftTime)) {
                status = 'On time';
              }

              attendance.doc(loggedInUser.uid).set({
                "empId": loggedInUser.uid,
                "firstName": loggedInUser.firstName,
                "lastName": loggedInUser.lastName,
                "timeIn": formattedTime,
                "timeOut": "-",
              });

              CollectionReference reportAttendance =
                  FirebaseFirestore.instance.collection('attendance');

              reportAttendance.doc(loggedInUser.uid).set({
                formattedDate: {
                  "date": formattedDate,
                  "timeIn": formattedTime,
                  "timeOut": "-",
                  "overTime": "-",
                  "underTimeStatus": "-",
                  "status": status
                }
              }, SetOptions(merge: true));
            } else if (widget.attendanceStatus == 'Time out') {
              CollectionReference attendance =
                  FirebaseFirestore.instance.collection(formattedDate);

              String diff = '-';
              String underTimeStatus = '-';
              DateTime endShiftTime =
                  DateTime.parse(formattedDate + " 17:00:00");

              if (now.isAfter(endShiftTime)) {
                diff = now.difference(endShiftTime).inHours.toString();
                underTimeStatus = 'no';
              } else if (now.isBefore(endShiftTime)) {
                diff = '0';
                underTimeStatus = 'yes';
              }

              attendance.doc(loggedInUser.uid).update({
                "timeOut": formattedTime,
              });

              CollectionReference reportAttendance =
                  FirebaseFirestore.instance.collection('attendance');

              reportAttendance.doc(loggedInUser.uid).set({
                formattedDate: {
                  "timeOut": formattedTime,
                  "overTime": diff,
                  "underTimeStatus": underTimeStatus,
                }
              }, SetOptions(merge: true));
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Attendance Recorded Successfully!'),
                duration: const Duration(days: 365),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ),
            );
            controller.dispose();
            Navigator.of(context).pop();
          } else {
            isQrValid = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Invalid QR Code!'),
                duration: const Duration(days: 365),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ),
            );
            controller.dispose();
            Navigator.of(context).pop();
            result = null;
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }
}

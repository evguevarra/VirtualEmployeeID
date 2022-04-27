import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_emp/model/user_model.dart';
import 'package:virtual_emp/views/main_frame.dart';
import 'package:virtual_emp/views/numeric_pad.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({Key? key}) : super(key: key);

  @override
  _PinVerificationPageState createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
      appBar: AppBar(
        title: const Text("PIN VERIFICATION"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                "Enter your pin",
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: PinCodeTextField(
              obscureText: true,
              keyboardType: TextInputType.number,
              appContext: context,
              length: 4,
              onChanged: (String value) {
                print(value);
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                inactiveColor: Colors.grey,
                activeColor: Colors.black,
              ),
              onCompleted: (value) {
                if (value == loggedInUser.pin) {
                  Fluttertoast.showToast(
                      msg: "Pin Verification Successful",
                      toastLength: Toast.LENGTH_LONG);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MainFrame()));
                } else {
                  Fluttertoast.showToast(
                      msg: "Invalid Pin", toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

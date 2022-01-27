import 'package:flutter/material.dart';
import 'package:virtual_emp/main_frame.dart';
import 'package:virtual_emp/numeric_pad.dart';

class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({Key? key}) : super(key: key);

  @override
  _PinVerificationPageState createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PIN VERIFICATION"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                "Enter your pin",
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPinBox(code.isNotEmpty ? code.substring(0, 1) : ""),
                buildPinBox(code.length > 1 ? code.substring(1, 2) : ""),
                buildPinBox(code.length > 2 ? code.substring(2, 3) : ""),
                buildPinBox(code.length > 3 ? code.substring(3, 4) : ""),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MainFrame()));
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: const StadiumBorder(),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.30, 40),
              ),
            ),
          ),
          NumericPad(
            onNumberSelected: (value) {
              setState(() {
                if (value != -1) {
                  if (code.length < 4) {
                    code = code + value.toString();
                  }
                } else {
                  code = code.substring(0, code.length - 1);
                }
              });
              print(code);
            },
          ),
        ],
      ),
    );
  }

  Widget buildPinBox(String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Container(
          child: Column(
            children: [
              Center(
                child: Text(
                  code,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 60,
                height: 5,
                color: Colors.grey.shade400,
              )
            ],
          ),
        ),
      ),
    );
  }
}

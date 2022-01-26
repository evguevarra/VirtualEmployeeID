import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_emp/signin_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.red),
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 0,
            child: Image(
              image: const AssetImage('assets/workspace.jpg'),
              color: Colors.red,
              colorBlendMode: BlendMode.darken,
              height: MediaQuery.of(context).size.height * 0.60,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 80,
            left: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Virtual\nEmployee\nID",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: 8,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Byaheros Express - Nasugbu",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SigninCard(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

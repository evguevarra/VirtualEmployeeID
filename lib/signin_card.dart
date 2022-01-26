import 'package:flutter/material.dart';

class SigninCard extends StatefulWidget {
  const SigninCard({Key? key}) : super(key: key);

  @override
  _SigninCardState createState() => _SigninCardState();
}

class _SigninCardState extends State<SigninCard> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    return Container(
      color: Colors.white,
      child: Form(
        key: _key,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.50,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Email Address"),
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
              ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   color: Colors.white,
    //   height: MediaQuery.of(context).size.height * 0.50,
    //   width: MediaQuery.of(context).size.width * 0.85,
    // );
  }
}

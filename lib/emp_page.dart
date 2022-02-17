import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_emp/user_model.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
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
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Employee ID',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        buildEmptyPhoto(),
        const SizedBox(
          height: 40,
        ),
        buildInfoSection(),
      ],
    );
  }

  Widget buildInfoSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .20,
      width: MediaQuery.of(context).size.height * .40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ID code: \n${loggedInUser.uid}',
            textAlign: TextAlign.center,
          ),
          Text(
            'Full name: \n${loggedInUser.firstName} ${loggedInUser.middleInitial}. ${loggedInUser.lastName}',
            textAlign: TextAlign.center,
          ),
          Text(
            'Position: \n${loggedInUser.position}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildEmptyPhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * .30,
              width: MediaQuery.of(context).size.height * .30,
            ),
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text('Photo'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

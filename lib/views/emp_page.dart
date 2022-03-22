import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:virtual_emp/model/user_model.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? imageUrl;

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
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      color: Colors.grey,
                      height: MediaQuery.of(context).size.height * .30,
                      width: MediaQuery.of(context).size.height * .30,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: (imageUrl != null)
                            ? Image.network(imageUrl!)
                            : const Text('Photo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: const Text(
                'Update ID Photo',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: const RoundedRectangleBorder(),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 30),
              ),
            ),
          ],
        ),
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

  uploadImage() async {
    CollectionReference users =
                  FirebaseFirestore.instance.collection('users');
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);
      String imageLink;
      if (image != null) {
        var snapshot = await _storage.ref().child('/${loggedInUser.uid}').putFile(file);
        var downloadURL = await snapshot.ref.getDownloadURL();

        users.doc(loggedInUser.uid).update({
          "imageLink": downloadURL,
        });

        // users.doc(loggedInUser.uid).get().then((snapshot){
        //   imageLink=snapshot.data["imageLink"];
        // });

        setState(() {
          imageUrl = downloadURL;
        });


      } else {
        print('No path received');
      }
    } else {
      print('try again!');
    }
  }
}

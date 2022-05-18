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
                FutureBuilder<Widget>(
                    future: _getImage(context, loggedInUser.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.height * .30,
                          child: snapshot.data,
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.height * .30,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.none ||
                          snapshot.data == null) {
                        return Container(
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.height * .30,
                          child: Image.network(
                            'https://www.flaticon.com/free-icon/user_1077012?related_id=1077012',
                            fit: BoxFit.scaleDown,
                          ),
                        );
                      }
                      return Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.height * .30,
                        width: MediaQuery.of(context).size.height * .30,
                        child: Image.network(
                          'https://www.flaticon.com/free-icon/user_1077012?related_id=1077012',
                          fit: BoxFit.scaleDown,
                        ),
                      );
                    }),
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

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    late Image image;
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  uploadImage() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
        var snapshot =
            await _storage.ref().child('/${loggedInUser.uid}').putFile(file);
      } else {
        print('No path received');
      }
    } else {
      print('try again!');
    }
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}

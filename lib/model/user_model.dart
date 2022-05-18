import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? middleInitial;
  String? gender;
  String? birthdate;
  String? address;
  String? contactNumber;
  String? email;
  //String? imagelink;
  String? position;
  String? pin;

  UserModel(
      {this.uid,
      this.firstName,
      this.lastName,
      this.middleInitial,
      this.gender,
      this.birthdate,
      this.address,
      this.contactNumber,
      this.email,
      this.position,
      this.pin});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['empId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      middleInitial: map['middleInitial'],
      gender: map['gender'],
      birthdate: map['birthdate'],
      address: map['address'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      position: map['position'],
      pin: map['pin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empId': uid,
      'firstName': firstName,
      'lastName': lastName,
      'middleInitial': middleInitial,
      'gender': gender,
      'birthdate': birthdate,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'position': position,
      'pin': pin,
    };
  }
}

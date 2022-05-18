import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_emp/model/user_model.dart';

class AddLeaveForm extends StatefulWidget {
  const AddLeaveForm({Key? key}) : super(key: key);

  @override
  State<AddLeaveForm> createState() => _AddLeaveFormState();
}

class _AddLeaveFormState extends State<AddLeaveForm> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime date = DateTime.now();

  String initialDropdownValue = 'Sick Leave';

  List<String> typeItems = [
    'Sick Leave',
    'Vacation Leave',
    'Emergency Leave',
    'Maternity Leave',
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference leaveRequest =
        FirebaseFirestore.instance.collection('leaves');

    Future<void> addRequest() {
      return leaveRequest
          .doc(loggedInUser.uid)
          .set({
            'empId': loggedInUser.uid,
            'lastname': loggedInUser.lastName,
            'firstname': loggedInUser.firstName,
            'from': fromController.text,
            'to': toController.text,
            'duration': durationController.text,
            'type': initialDropdownValue,
            'description': descriptionController.text,
            'status': 'Pending',
          })
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Request Submitted", toastLength: Toast.LENGTH_LONG)
              })
          .catchError((error) => {
                Fluttertoast.showToast(
                    msg: "Request Submission Failed; $error",
                    toastLength: Toast.LENGTH_LONG)
              });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Leave/Absence'),
        backgroundColor: Colors.red,
      ),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.80,
              child: Form(
                key: _key,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? fromDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100));

                            if (fromDate == null) return;
                            setState(() {
                              date = fromDate;
                              fromController.text =
                                  '${date.year}/${date.month}/${date.day}';
                            });
                          },
                          child: TextFormField(
                            controller: fromController,
                            readOnly: true,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? toDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100));

                            if (toDate == null) return;
                            setState(() {
                              if (fromController.text.isNotEmpty) {
                                date = toDate;
                                toController.text =
                                    '${date.year}/${date.month}/${date.day}';

                                DateTime fromDateParsed =
                                    DateFormat("yyyy-MM-dd").parse(
                                        fromController.text
                                            .replaceAll('/', '-'));
                                DateTime toDateParsed = DateFormat("yyyy-MM-dd")
                                    .parse(
                                        toController.text.replaceAll('/', '-'));

                                var differenceDate = toDateParsed
                                        .difference(fromDateParsed)
                                        .inDays +
                                    1;
                                if (differenceDate > 0) {
                                  durationController.text =
                                      ' ${differenceDate.toString()} ${differenceDate > 1 ? " days" : "day"}';
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Invalid Date! Choose a to date that is higher than from date",
                                      toastLength: Toast.LENGTH_LONG);
                                  durationController.text = '';
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Error! Choose a from-date first before choosing a to-date",
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            });
                          },
                          child: TextFormField(
                            controller: toController,
                            readOnly: true,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                              labelText: 'Select type',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          isEmpty: initialDropdownValue == '',
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            isDense: true,
                            onChanged: (value) {
                              setState(() {
                                initialDropdownValue = value!;
                              });
                            },
                            value: initialDropdownValue,
                            items: typeItems.map((String items) {
                              return DropdownMenuItem<String>(
                                  value: items, child: Text(items));
                            }).toList(),
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: durationController,
                          readOnly: true,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Duration',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (fromController.text.isNotEmpty &&
                                    toController.text.isNotEmpty &&
                                    durationController.text.isNotEmpty &&
                                    descriptionController.text.isNotEmpty) {
                                  addRequest();
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Error Please Fill all blanks!',
                                      toastLength: Toast.LENGTH_LONG);
                                }
                              },
                              child: const Text(
                                'Submit Request',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * .40,
                                    40),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                      width: 2.0, color: Colors.red),
                                ),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * .40,
                                    40),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

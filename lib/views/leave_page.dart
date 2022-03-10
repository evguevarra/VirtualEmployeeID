

import 'package:flutter/material.dart';
import 'package:virtual_emp/views/add_leave_form.dart';

class LeaveAbsencePage extends StatefulWidget {
  const LeaveAbsencePage({ Key? key }) : super(key: key);

  @override
  State<LeaveAbsencePage> createState() => _LeaveAbsencePageState();
}

class _LeaveAbsencePageState extends State<LeaveAbsencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave/Absence'),
        backgroundColor: Colors.red,
      ),
      body: Column(children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.80,
          child: const Center(
            child: Text(
              'No  current leaves/absence filed',
              style: TextStyle(
                color: Colors.grey
              ),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddLeaveForm()));
                },
                child: const Text(
                  'Add a Request for Leave/Absence',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: const RoundedRectangleBorder(),
                  minimumSize: Size(MediaQuery.of(context).size.width, 40),
                  
                ),
              ),
        ),
      ],),
    );
  }
}
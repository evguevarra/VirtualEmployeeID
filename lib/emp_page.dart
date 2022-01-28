import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
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
      height: MediaQuery.of(context).size.height * .10,
      width: MediaQuery.of(context).size.height * .10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('ID no: '),
          Text('Full name: '),
          Text('Position: '),
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

import 'package:flutter/material.dart';
import 'package:virtual_emp/scanner_page.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScannerPage()));
            },
            icon: const Icon(
              Icons.qr_code_scanner_sharp,
              size: 40,
            ),
            label: const Text(
              '    Attendance Scanner',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.90,
                  MediaQuery.of(context).size.height * 0.15),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.border_color,
                size: 40,
              ),
              label: const Text(
                '    File Leave/Vacation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade700,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90,
                    MediaQuery.of(context).size.height * 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

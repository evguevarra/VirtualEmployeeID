import 'package:flutter/material.dart';

class AddLeaveForm extends StatefulWidget {
  const AddLeaveForm({Key? key}) : super(key: key);

  @override
  State<AddLeaveForm> createState() => _AddLeaveFormState();
}

class _AddLeaveFormState extends State<AddLeaveForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  DateTime date = DateTime.now();

  String initialDropdownValue = 'Sick Leave';

  List<String> typeItems = [
    'Sick Leave',
    'Vacation Leave',
    'Emergenct Leave',
    'Maternity Leave',
  ];

  @override
  Widget build(BuildContext context) {
    
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
                              fromController.text = '${date.year}/${date.month}/${date.day}';
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
                              date = toDate;
                              toController.text = '${date.year}/${date.month}/${date.day}';
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
                              onPressed: () {},
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
                              onPressed: () {},
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

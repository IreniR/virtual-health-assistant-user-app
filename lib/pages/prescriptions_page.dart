import 'package:flutter/material.dart';

class PrescriptionPage extends StatefulWidget {
  static const String id = 'prescription_page';

  @override
  _PrescriptionPage createState() => _PrescriptionPage();
}

class _PrescriptionPage extends State<PrescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Prescriptions'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined,
                  size: 20, color: Colors.white),
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionPage(),
                    ));
              },
            )),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active prescription info',
                          style: TextStyle(fontSize: 15)),
                      InkWell(onTap: () {}, child: Icon(Icons.cloud_download)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

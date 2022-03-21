import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:health_assistant/model/event_model.dart';
import 'package:health_assistant/pages/appts_page.dart';
import 'package:health_assistant/utils/events/event_firestore.dart';
import 'package:health_assistant/utils/notifications.dart';
import 'package:intl/intl.dart';

class MakeApptPage extends StatefulWidget {
  static const String id = 'make_appt_page';
  final DateTime pickedDate;
  final EventModel event;
  MakeApptPage({this.pickedDate, this.event});

  @override
  _MakeApptPageState createState() => _MakeApptPageState();
}

class _MakeApptPageState extends State<MakeApptPage> {
  final _formAppointmentkey = GlobalKey<FormBuilderState>();

  Map<DateTime, List<EventModel>> selectedEvents =
      <DateTime, List<EventModel>>{};

  ValueChanged _onChanged = (val) => print(val);

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String desc;
  DateTime date;
  DateTime timeOfDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Make A Reminder',
              style: TextStyle(color: Colors.pink.shade900)),
          leading: IconButton(
            key: Key('makeApptsBackBtn'),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.pink.shade900,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => AppointmentsPage()));
            },
          ),
        ),
        body: FormBuilder(
            key: _formAppointmentkey,
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.centerRight,
                      radius: 2,
                      colors: [
                    Colors.amber.shade50,
                    Colors.pink.shade50,
                    Colors.purple.shade100
                  ])),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 65)),
                  FormBuilderTextField(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    name: "title",
                    initialValue: widget.event?.title,
                    decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 45)),
                  ),
                  FormBuilderTextField(
                    name: "desc",
                    initialValue: widget.event?.desc,
                    decoration: InputDecoration(
                        hintText: "Description",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 45)),
                  ),
                  FormBuilderDateTimePicker(
                    name: "date",
                    initialValue: widget.event != null
                        ? widget.event.date
                        : widget.pickedDate ?? DateTime.now(),
                    fieldHintText: "Add a Date",
                    inputType: InputType.date,
                    enabled: false,
                    format: DateFormat('EEEE, dd MMMM, yyyy'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 45)),
                  ),
                  FormBuilderDateTimePicker(
                    name: 'timeOfDay',
                    onChanged: _onChanged,
                    inputType: InputType.time,
                    initialTime: TimeOfDay(hour: 9, minute: 0),
                    initialValue: widget.event?.timeOfDay,
                    format: DateFormat('HH:mm a'),
                    decoration: InputDecoration(
                        labelText: "Time of Appointment",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 45)),
                  ),
                  //buildButton() onclick notification
                  submitBtn() //schedule Notification
                ],
              ),
            ))));
  }

  Widget buildButton() {
    return Container(
      child: ElevatedButton(
        onPressed: () => NotificationApi.showNotification(
            title: "Notification worked",
            body: "Hey! It is working",
            payload: 'sample.notification'),
        child: Text('Here'),
      ),
    );
  }

  Widget submitBtn() {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: ElevatedButton(
        key: Key('submitEventBtn'),
        onPressed: () async {
          if (_formAppointmentkey.currentState.validate()) {
            print('successfully made event');
            _formAppointmentkey.currentState.save();

            print(_formAppointmentkey.currentState.context);
            final data = Map<String, dynamic>.from(
                _formAppointmentkey.currentState.value);

            data['date'] = (data['date'] as DateTime).millisecondsSinceEpoch;
            data['timeOfDay'] =
                (data['timeOfDay'] as DateTime).millisecondsSinceEpoch;
// DateTime.fromMillisecondsSinceEpoch(data['timeOfDay']);

            if (widget.event == null) {
              data['user_id'] = FirebaseAuth.instance.currentUser.email;
              print(data);

              await eventDatabaseService.create(data);
              //create new event in firestore

              // print((data['timeOfDay']));
              DateTime dt = (data['timeOfDay'] as DateTime);

              print(dt);
              //format this to get value of actual date

              // String dt = DateFormat('hh:mm a').format(data['timeOfDay']);
              // print(dt);

              // String setHr = DateFormat('HH').format(widget.event.timeOfDay);

              // String setMin = DateFormat("mm").format(widget.event.timeOfDay);
              // print(int.parse(setHr));
              // print(int.parse(setMin));

              // NotificationApi.showScheduledNotification(
              //     title: titleController.text,
              //     body: descController.text,
              //     payload: widget.event.id.toString(),
              //     scheduledDate: widget.pickedDate.add(Duration(
              //         hours: int.parse(setHr), minutes: int.parse(setMin))));
            } else {
              //remove before being updated
              await eventDatabaseService.updateData(widget.event.id, data);
            }

            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => AppointmentsPage()));
            titleController.clear();
            setState(() {});
            return;
          } else {
            print('Did not make event error');
          }
        },
        child: Text(
          'Confirm',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 60),
            primary: Colors.cyan,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}

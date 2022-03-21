import 'package:flutter/material.dart';
import 'package:health_assistant/model/event_model.dart';
import 'package:health_assistant/pages/make_appt.dart';
import 'package:health_assistant/utils/events/event_firestore.dart';
import 'package:intl/intl.dart';

class ViewEventPage extends StatefulWidget {
  static const String id = 'view_event_page';
  final EventModel event;

  const ViewEventPage({Key key, this.event}) : super(key: key);

  @override
  _ViewEventPage createState() => _ViewEventPage();
}

class _ViewEventPage extends State<ViewEventPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink.shade100,
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              //edit
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MakeApptPage(event: widget.event)));
                  }),
              //delete
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Delete Reminder"),
                                  content: Text("Verify Deletion of Reminder"),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text("Delete")),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text("Cancel"))
                                  ],
                                )) ??
                        false;

                    if (confirm) {
                      await eventDatabaseService.removeItem(widget.event.id);
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(15),
            children: [
              ListTile(
                leading: Icon(Icons.event),
                title: Text(widget.event.title),
                subtitle: Text(
                    DateFormat("EEE, dd MMMM, yyyy").format(widget.event.date)),
              ),
              SizedBox(height: 10),
              if (widget.event.desc != null)
                ListTile(
                    leading: Icon(Icons.short_text),
                    title: Text(widget.event.desc),
                    subtitle: Text(
                        DateFormat("HH:mm a").format(widget.event.timeOfDay))),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/model/event_model.dart';
import 'package:health_assistant/pages/make_appt.dart';
import 'package:health_assistant/pages/view_event.dart';
import 'package:health_assistant/utils/events/event_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsPage extends StatefulWidget {
  static var id;

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  CalendarController _controller;
  List<dynamic> _selectedEvents;

  final GlobalKey<FormState> _formAppointmentkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _selectedEvents = [];
  }

  Map<DateTime, List<EventModel>> _groupedEvents;

  _events(List<EventModel> events) {
    _groupedEvents = {};
    events.forEach((event) {
      DateTime date =
          DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if (_groupedEvents[date] == null) {
        _groupedEvents[date] = [];
      }
      _groupedEvents[date].add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  center: Alignment.centerRight,
                  radius: 2,
                  colors: [
                Colors.amber.shade50,
                Colors.pink.shade50,
                Colors.purple.shade100
              ])),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  children: [
                    IconButton(
                      key: Key('apptsBackBtn'),
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.pink.shade900,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentsPage()));
                      },
                    ),
                    Text('Schedule A Reminder',
                        style: TextStyle(
                            color: Colors.pink.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                StreamBuilder(
                    stream: eventDatabaseService.streamQueryList(args: [
                      QueryArgsV2("user_id",
                          isEqualTo: FirebaseAuth.instance.currentUser.email)
                    ]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<EventModel> events = snapshot.data;
                        _events(events);
                        DateTime selectedDate = _controller.selectedDay;
                        final _selectEvents =
                            _groupedEvents[selectedDate] ?? [];
                        return Column(children: <Widget>[
                          Card(
                              child: TableCalendar(
                            events: _groupedEvents,
                            initialCalendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                                markersColor: Colors.pink.shade100,
                                canEventMarkersOverflow: true,
                                todayColor: Colors.pink.shade200,
                                selectedColor: Colors.pink.shade300,
                                todayStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black)),
                            headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.pink.shade600,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              formatButtonTextStyle:
                                  TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            onDaySelected: (date, events, holidays) {
                              setState(() {});
                            },
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.pink.shade700,
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                              todayDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.pink.shade200,
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                            calendarController: _controller,
                          )),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _selectEvents.length,
                              itemBuilder: (BuildContext context, int index) {
                                EventModel event = _selectEvents[index];
                                return ListTile(
                                  title: Text(event.title),
                                  subtitle: Text(
                                      DateFormat("EEEE, dd MMMM, yyyy")
                                          .format(event.date)),
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewEventPage(event: event)))
                                  },
                                );
                              })
                        ]);
                      }
                      return CircularProgressIndicator();
                    }),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade600,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MakeApptPage(
                        pickedDate: _controller.selectedDay,
                      )));
        },
        foregroundColor: Colors.white,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDay;
  DateTime currentDate = DateTime.now();
  List<dynamic> selectedEvents;
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  TextEditingController _textEditingController;

  void initState() {
    super.initState();
    _calendarController = CalendarController();
    selectedDay = DateTime.now();
    selectedEvents = [];
    _events = {};
    _textEditingController = TextEditingController();
  }

  void _daySelected(DateTime day, List listedDates, List holidays) {
    setState(() {
      selectedDay = day;
      selectedEvents = listedDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        calendarController: _calendarController,
        calendarStyle: CalendarStyle(
          canEventMarkersOverflow: true,
          markersColor: Colors.white,
          renderDaysOfWeek: false,
        ),
        onDaySelected: _daySelected,
      ),
    );
  }
}

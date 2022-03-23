import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:health_assistant/constants/string_constants.dart';
import 'package:health_assistant/model/event_model.dart';

final eventDatabaseService = DatabaseService<EventModel>(
    AppConstants.eventsCollection,
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/event_model.dart';

ValueNotifier<List<EventModel>> eventNotifier = ValueNotifier([]);

class EventDb {
  Future<void> saveEvent(EventModel event) async {
    final eventBox = await Hive.openBox<EventModel>('event_db');
    eventBox.add(event);
    eventNotifier.value = eventBox.values.toList();
    eventNotifier.notifyListeners();
  }

  Future<EventModel?> getLatestEvents() async {
    final eventBox = await Hive.openBox<EventModel>('event_db');
    if (eventBox.isEmpty) {
      return null;
    } else {
      final latestEvent = eventBox.values.last;
      return latestEvent;
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    final eventBox = await Hive.openBox<EventModel>('event_db');
    return eventBox.values.toList();
  }

  Future<void> deleteEvent(EventModel event) async {
    final eventBox = await Hive.openBox<EventModel>('event_db');
    final eventIndex =
        eventBox.values.toList().indexWhere((events) => event.id == events.id);
    eventBox.deleteAt(eventIndex);
    eventNotifier.notifyListeners();
  }

  Future<void> editEvent(int eventId, EventModel newEvent) async {
    final eventBox = await Hive.openBox<EventModel>('event_db');
    final eventIndex =
        eventBox.values.toList().indexWhere((events) => eventId == events.id);
    eventBox.putAt(eventIndex, newEvent);
    eventNotifier.notifyListeners();
  }
}

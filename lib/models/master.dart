import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../state.dart';
import '../models.dart';


class Master implements Doc {
  final String id;
  final String firstName; 
  final String? lastName; 
  final BuiltSet services;
  final BuiltSet<WorkingHours> workingHours7days;

  Master({
      required this.id,
      required this.firstName,
      this.lastName,
      required this.workingHours7days,
      required this.services,
  }); 

  String toString() {
    return "$firstName ${lastName ?? ''}";
  }
  
  // BuiltSet<Event> eventsIn(Iterable<DateTime> dates) => eventsList;
}



class MasterEditClose with UIEventsDesc implements UIEvent {
  
  MasterEditClose();
  
  perform() {
    Masters.selected.value = null;
  }

}

class MasterCreate with UIEventsDesc implements UIEvent {
  
  MasterCreate();
  
  perform() {
  }

}

class MasterUpdate with UIEventsDesc implements UIEvent {
  
  BuiltSet<Service>? services;
  
  MasterUpdate({this.services});
  
  perform() {
  }

}

class MasterEdit with UIEventsDesc implements UIEvent {

  Master master;
  
  MasterEdit(this.master);
  
  perform() {
    Masters.selected.value = master;
  }
  
  String get desc => "${master.id}";

}


class Masters {
  static var selected = ValueNotifier<Master?>(null);

}

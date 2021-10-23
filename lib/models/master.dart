import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../state.dart';
import '../models.dart';
import '../utils.dart';
import 'dart:collection';

class Master implements Doc {
  final String id;
  final String firstName; 
  final String? lastName; 
  final BuiltSet<Service> services;

  Master({
      required this.id,
      required this.firstName,
      this.lastName,
      // required this.workingHours7days,
      required this.services,
  }); 

  Master copyWith({id, firstName, lastName, services,}) {
    return Master(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      services: services ?? this.services,
   );
  }

  String toString() {
    return "$firstName ${lastName ?? ''}";
  }
  
  // BuiltSet<Event> eventsIn(Iterable<DateTime> dates) => eventsList;
}


class MasterWorkingHoursToggle with UIEventsDesc implements UIEvent {
  WorkingHours wh;
  bool isOn;
  
  MasterWorkingHoursToggle(this.wh, this.isOn);

  perform() {
    var hours = {wh.copyWith(dayOff: !isOn)}
    .build()
    .union(Masters.workingHours.value);
    
    Masters.workingHours.value = BuiltSet();
    Masters.workingHours.value = hours;
  }
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
    Masters.selected.value =
    Masters.selected.value?.copyWith(services: services);
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
  static var workingHours = ValueNotifier<BuiltSet<WorkingHours>>(BuiltSet());
  static var onWorkingHoursUpdate = ValueNotifier<int>(0);

  static void init() {
    afterEvent([MasterWorkingHoursToggle], onWorkingHoursUpdate);
  }
 
  static Iterable<WorkingHours> masterWorkingHours7days(DateTime fromDate) {
    return SplayTreeSet<WorkingHours>.from(
      DateRange.from(fromDate)
      .take(7)
      .map((date) {
          var wh = WorkingHours(
            date: date,
            work:  [[9, 00], [18, 00]],
            lunch: [[14, 00], [15, 00]]
          );
          
          return workingHours.value.lookup(wh) ?? wh;
        }
      )
    );
  }
}

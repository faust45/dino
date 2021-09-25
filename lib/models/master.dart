import 'package:built_collection/built_collection.dart';
import '../models.dart';


class Master implements Doc {
  final String id;
  final String firstName; 
  final String? lastName; 
  final BuiltSet<Service> services;
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

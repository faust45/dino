import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils.dart';
import 'package:built_collection/built_collection.dart';


abstract class Doc {
  
}


class Client implements Doc {
  final String id;   
  final String firstName;
  final String? lastName;   
  final String? phoneNumber;   
  final String? telegram;   

  Client({
      required this.id,
      required this.firstName,
      this.lastName,
      this.phoneNumber,
      this.telegram});
  
  String toString() {
    return "$firstName ${lastName ?? ''}";
  }
}


class Service implements Doc {
  final String id;
  final String name; 
  final String cat; 
  final int duration;
  final int price;

  Service({required this.id, required this.name, required this.cat,
      required this.price, required this.duration,}); 

  @override
  Service copyWith({String? name, String? cat, int? price, int? duration,}) {
    return Service(
      id: this.id,
      cat: cat ?? this.cat,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration
    );
  }

  String toString() {
    return "Service(${id} ${name})";
  }
}

class WorkingHours implements Comparable, Doc {
  static DateFormat format = DateFormat('yy-MM-dd');

  DateTime date;
  List<dynamic> work, lunch;
  bool dayOff, haveLunch; 

  WorkingHours({
      required this.date,
      this.work = const [],
      this.lunch = const [],
      this.dayOff = true,
      this.haveLunch = true}) {
    this.date = DateTime(date.year, date.month, date.day);
  }

  WorkingHours copyWith({date, work, lunch, dayOff, haveLunch,}) {
    return WorkingHours(
      date: date ?? this.date,
      work:  work ?? this.work,
      lunch: lunch ?? this.lunch,
      dayOff: dayOff ?? this.dayOff,
      haveLunch: haveLunch ?? this.haveLunch,
   );
 }
 @override
 int compareTo(o) => date.compareTo(o.date);

 @override
 bool operator ==(Object o) { 
   return this.date == (o as WorkingHours).date;
 }

 int get hashCode => date.hashCode;

 String toString() => "${format.format(date)} $dayOff";
}


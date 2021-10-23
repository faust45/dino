import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:time_range_picker/time_range_picker.dart' as tpicker;
// import 'package:reactive_state/reactive_state.dart' as rs;
// import './utils/rx_value.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:time_range_picker/time_range_picker.dart' as tpicker;



DateTime today() {
  return DateTime.now();
}

Widget inputCaption(BuildContext context, String caption) => 
Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Center(
    child: Text(
      caption,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
[for (var sublist in list) ...sublist];

Iterable<int> range(int from, int to) sync* {
  for (int i = from; i <= to; ++i) {
    yield i;
  }
}

TextStyle? color(cond, color) {
  return cond ? TextStyle(color: color) : null;
}


class fmt {
  static var wday = DateFormat('E');
  static var fmonth = DateFormat('MMMM');
  static var fdate = DateFormat('MMMMEEEEd');
  static var ftime = DateFormat('Hm');
  
  static String weekDay(DateTime date) {
     return wday.format(date);
  }

  static String month(DateTime date) {
     return fmonth.format(date);
  }

  static String fullDate(DateTime date) {
    return fdate.format(date);    
  }

  static String time(DateTime date) {
    return ftime.format(date);    
  }

  static String timeRange (tpicker.TimeRange? t) {
    if (t != null) {
      return "${timeOfDay(t.startTime)} - ${timeOfDay(t.endTime)}";
    } else {
      return "";
    }
  }

  static String _addLeadingZero(int value) {
    if (value < 10)
    return '0$value';
    return value.toString();
  }

  static String timeOfDay (TimeOfDay t) {
    final String hourLabel = _addLeadingZero(t.hour);
    final String minuteLabel = _addLeadingZero(t.minute);

    return '$hourLabel:$minuteLabel';
  }

  // static String timeRange (tpicker.TimeRange t) {
  //   if (t != null) {
  //     return "${timeOfDay(t.startTime)} - ${timeOfDay(t.endTime)}";
  //   } else {
  //     return "";
  //   }
  // }

  static String dtRange(List data) {
    var aHour = _addLeadingZero(data[0][0]),
        aMinute = _addLeadingZero(data[0][1]),
        bHour =_addLeadingZero(data[1][0]),
        bMinute = _addLeadingZero(data[1][1]);

    return "${aHour}:${aMinute} - ${bHour}:${bMinute}";
  }
  
  static String price(v) {
    return "$v";
  }
}

class Validator {
  static String? notEmpty(String? value) {
    if (value != null && value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

}


DateTime todayAt(int hour, int minutes) {
  var d = DateTime.now();
  return DateTime(d.year, d.month, d.day, hour, minutes);
}

DateTime dateTime(DateTime d, TimeOfDay t) {
  var a = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  return a;
}

class Date {
  static DateTime create(DateTime d, TimeOfDay t) {
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
}

extension DateTimeExt on DateTime {
  DateTime beginningOfDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime atTime(hour, minutes) {
    return DateTime(this.year, this.month, this.day, hour, minutes);
  }
  
  DateTime get nextMonth => DateTime(this.year, this.month + 1, 1);
  
  DateTime get prevMonth => DateTime(this.year, this.month - 1, 1);
}

class DateRange {

  static Iterable<DateTime> week() {
    return from(DateTime.now()).take(7);
  }

  static Iterable<DateTime> from(DateTime date) {
    var startFrom = DateTime(date.year, date.month, date.day);

    return range(0, double.maxFinite.toInt()).map((i) =>
      startFrom.add(Duration(days: i))
    );
  }
}

String genId() {
  var rng = new Random();
  return List.generate(12, (_) => rng.nextInt(100)).toString();
}

bool isNull(v) {
  return (v == null);
}

bool notNull(v) {
  return !isNull(v);
}

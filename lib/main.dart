import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'utils.dart';
import 'state.dart';
import 'models/calendar.dart' as cal;
import 'utils/rx_value.dart';
import 'screen/calendar_screen.dart';
import 'screen/calendar_event_edit_screen.dart';


void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ValueListenableBuilder(
        valueListenable: pages,
        builder: (context, value, child) {
          return Navigator(
            pages: value as List<Page>,
            onPopPage: (route, result) {
              return route.didPop(result);
            }
          );
        }
      ),
    );
  }
}


var pages = ~(_) {
  return [
    MaterialPage(child: CalendarScreen()),
    if(_(cal.Calendar.selectedEvent) != null) 
    MaterialPage(child: CalendarEventEditScreen())
  ];
};



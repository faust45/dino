import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'utils.dart';
import 'state.dart';
import 'models/calendar.dart' as cal;
import 'models/master.dart';
import 'utils/rx_value.dart';
import 'screen/calendar_screen.dart';
import 'screen/calendar_event_edit_screen.dart';
import 'screen/masters/masters_screen.dart';
import 'screen/masters/masters_edit_screen.dart';


void main() {
  // debugRepaintRainbowEnabled = true;
  AppState.init();
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


var pages = ValueNotifier([
    MaterialPage(child: MastersScreen()),
    MaterialPage(child: MastersEditScreen())
  ]
);
// var pages = ~(_) {
//   switch(_(AppState.mainPage)) {
//     case Pages.Masters:
//       return [
//         MaterialPage(child: MastersScreen()),
//         if(_(Masters.selected) != null) 
//         MaterialPage(child: MastersEditScreen())
//       ];
//     case Pages.Calendar:
//       return [
//         MaterialPage(child: CalendarScreen()),
//         if(_(cal.Calendar.selectedEvent) != null) 
//         MaterialPage(child: CalendarEventEditScreen())
//       ];
//   };
// };



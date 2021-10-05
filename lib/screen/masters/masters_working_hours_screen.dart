import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import "package:collection/collection.dart";
import '../../state.dart';
import '../../models.dart';
import '../../models/master.dart';
import '../../utils.dart';
import 'package:intl/intl.dart';
import 'package:built_collection/built_collection.dart';


Widget workingHoursWeek(context, BuiltSet<WorkingHours> masterWorkingHours7days) {
  var format = DateFormat('E');
  var dm = DateFormat('dd');

  return ListView(
    scrollDirection: Axis.vertical, 
    children: [
      ListTile(
        title: Row(
          children: [
            SizedBox(width: 50),
            Icon(Icons.access_time_outlined),
            SizedBox(width: 100),
            Icon(Icons.free_breakfast_outlined),
          ]
        )
      ),
      for(var wh in masterWorkingHours7days)
      InkWell(
        onTap: () async {
          // Map result = await openScreen(context, workLunchTimeEdit);
          // emit(
          //   [Comp.Masters, Sub.WorkingHours, Act.Update],
          //   Tuple2(wh, result)
          // );
        },
        child: ListTile(
          title: Row(
            children: [
              SizedBox(
                width: 50.0,
                child: Text(
                  format.format(wh.date),
                  style: color(!wh.dayOff, Colors.green)
                )
              ),
              if (wh.work != null)
              Row(
                children: [
                  Text("${fmt.dtRange(wh.work)}"),
                  SizedBox(width: 30),
                  Text("${fmt.dtRange(wh.lunch)}")
                ]
              ),
            ]
          ),
          subtitle: Text(
            dm.format(wh.date),
            style: color(!wh.dayOff, Colors.pink)
          ),
          trailing: Switch(
            value: !wh.dayOff, 
            onChanged: (bool isOn) {
              emit(MasterWorkingHoursUpdate(wh, isOn));
            }
          ), 
        ),
      )
    ]
  );
}

Future openScreen(context, screen) async {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: screen 
    )
  );
}


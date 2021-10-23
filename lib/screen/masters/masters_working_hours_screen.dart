import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import "package:collection/collection.dart";
import '../../state.dart';
import '../../models.dart';
import '../../models/master.dart';
import '../../utils.dart';
import '../../utils/ui_helpers.dart';
import '../../utils/rx_value.dart';
import 'package:intl/intl.dart';
import 'package:built_collection/built_collection.dart';
import 'package:time_range_picker/time_range_picker.dart' as tpicker;

Widget workingHoursWeek(context, Iterable<WorkingHours> masterWorkingHours7days) {
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
          openDialog(context, workLunchTimeEdit(context));
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
              emit(MasterWorkingHoursToggle(wh, isOn));
            }
          ), 
        ),
      )
    ]
  );
}

Widget workLunchTimeEdit(context) {
  ValueNotifier<tpicker.TimeRange?> workTime = ValueNotifier(null);
  ValueNotifier<tpicker.TimeRange?> lunchTime = ValueNotifier(null);

  Function timeRangeToMap = (tpicker.TimeRange t1, tpicker.TimeRange t2) {
    if (t1 != null && t2 != null) {
      return {
        #work: [
          [t1.startTime.hour, t1.startTime.minute],
          [t1.endTime.hour, t1.endTime.minute]
        ],
        #lunch: [
          [t2.startTime.hour, t2.startTime.minute],
          [t2.endTime.hour, t2.endTime.minute] 
        ]
      };
    } else {
      return {};
    }
  };
  // Map tr = timeRangeToMap(workTime.value, lunchTime.value);
  // emit([Comp.Masters, Sub.WorkingHoursHistory, Act.New], tr);
  
  return ~(ctx, _) =>
  Column(
    children: [
      Row(
        children: [
          Flexible(
            child: TextField(
              controller: TextEditingController(
                text: "${fmt.timeRange(_(workTime))}"
              ),
              onTap: () async {
                var result = await tpicker.showTimeRangePicker(
                  context: context,
                );
                workTime.value = result;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.access_time_outlined),
                labelText: "Working time",
              ),
            )
          ),
          Flexible(
            child: TextFormField(
              controller: TextEditingController(
                text: "${fmt.timeRange(lunchTime.value)}"
              ),
              onTap: () async {
                var result = await tpicker.showTimeRangePicker(
                  context: context,
                );
                lunchTime.value = result;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.free_breakfast_outlined ),
                labelText: "Lunch time",
              ),
            )
          ),
        ] 
      ),
      SizedBox(height: 50),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("or select from previous:"), 
      ),
      // for(var wltime in get(S.preferedWorkLunchTime)) 
      // ListTile(
      //   onTap: () {
      //     Navigator.pop(context, wltime);
      //   },
      //   title: Row(
      //     children: [
      //       SizedBox(width: 5),
      //       Text("${fmt.dtRange(wltime[#work])}"),
      //       SizedBox(width: 30),
      //       Text("${fmt.dtRange(wltime[#lunch])}")
      //     ]
      //   )
      // )
    ]
  );
}  

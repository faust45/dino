import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:reactive_state/reactive_state.dart';
import 'package:smart_select/smart_select.dart';
import '../../astate.dart';
import '../../models.dart';
import '../../utils.dart';
import 'package:time_range_picker/time_range_picker.dart' as tpicker;


Widget workLunchTimeEdit(context) {
  ValueNotifier<tpicker.TimeRange?> workTime = ValueNotifier(null);
  ValueNotifier<tpicker.n ?> lunchTime = ValueNotifier(null);

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

  return Scaffold(
    appBar: AppBar(
      leading: BackButton(
        onPressed: () { 
          // Map tr = timeRangeToMap(workTime.value, lunchTime.value);
          // emit([Comp.Masters, Sub.WorkingHoursHistory, Act.New], tr);
          // Navigator.pop(context, tr);
      }),
      title: Text("Work lunch time edit"),
    ),
    body: AutoBuild(builder: (context, get, track) =>
      Container()
      // Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           Flexible(
      //             child: TextField(
      //               controller: TextEditingController(
      //                 text: "${fmt.timeRange(get(workTime))}"
      //               ),
      //               onTap: () async {
      //                 var result = await tpicker.showTimeRangePicker(
      //                   context: context,
      //                 );
      //                 workTime.value = result;
      //               },
      //               decoration: const InputDecoration(
      //                 icon: Icon(Icons.access_time_outlined),
      //                 labelText: "Working time",
      //               ),
      //             )
      //           ),
      //           Flexible(
      //             child: TextFormField(
      //               controller: TextEditingController(
      //                 text: "${fmt.timeRange(get(lunchTime))}"
      //               ),
      //               onTap: () async {
      //                 var result = await tpicker.showTimeRangePicker(
      //                   context: context,
      //                 );
      //                 lunchTime.value = result;
      //               },
      //               decoration: const InputDecoration(
      //                 icon: Icon(Icons.free_breakfast_outlined ),
      //                 labelText: "Lunch time",
      //               ),
      //             )
      //           ),
      //         ] 
      //       ),
      //       SizedBox(height: 50),
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text("or select from previous:"), 
      //       ),
      //       for(var wltime in get(S.preferedWorkLunchTime)) 
      //       ListTile(
      //         onTap: () {
      //           Navigator.pop(context, wltime);
      //         },
      //         title: Row(
      //           children: [
      //             SizedBox(width: 5),
      //             Text("${fmt.dtRange(wltime[#work])}"),
      //             SizedBox(width: 30),
      //             Text("${fmt.dtRange(wltime[#lunch])}")
      //           ]
      //         )
      //       )
      //     ]
      //   )
      // )
    )
  );
}  

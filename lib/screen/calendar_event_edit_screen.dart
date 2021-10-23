import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/widgets.dart';
import '../app_drawer.dart';
import '../state.dart';
import '../utils.dart';
import '../models/calendar.dart' as cal;
import '../utils/rx_value.dart';
import '../utils/ui_helpers.dart';
import 'package:time/time.dart';
import 'package:built_collection/built_collection.dart';


class CalendarEventEditScreen extends StatelessWidget {
  const CalendarEventEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Event"),
        leading: BackButton(
          onPressed: () => emit(cal.CalEventEditClose()),
        )
      ),
      body: autow(editEvent, cal.Calendar.onEventUpdate)
    );
  }
}

Widget editEvent(e, ctx) {
  cal.Event event = cal.Calendar.selectedEvent.value!;
  
  return Padding(
    padding: EdgeInsets.only(left: 25, top: 50, right: 25),
    child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_sharp),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                var date = await showDatePicker(
                  context: ctx,
                  initialDate: event.startAt,
                  firstDate: today(),
                  lastDate: today() + 8.weeks
                );

                if(date != null) {
                  emit(cal.CalEventUpdate(startAtDate: date));
                }
              },
              child: Text(
                fmt.fullDate(event.startAt),
                style: textDateLabel
              )
            ),
          ]
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Icon(Icons.timer_sharp),
            SizedBox(width: 10),
            timeInput(ctx, event.startAt),
            SizedBox(width: 3),
            Text(
              " -- ",
              style: textLabel
            ),
            SizedBox(width: 3),
            durationInput(ctx, event.startAt, event.duration),
          ]
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 10),
            Text("${event.master}", style: textLabel),
            SizedBox(width: 10),
            Text("master", style: textLabel),
          ]
        ),
        SizedBox(height: 30),
        clientInput(ctx, event.client, AppState.clients.value),
        SizedBox(height: 30),
        servicesInput(ctx, event.services, event.master.services),
        SizedBox(height: 30),
        descInput(event.description),
        SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 35.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                  ),
                  child: Text("Cancel"),
                  onPressed: () {
                    emit(cal.CalEventCancel());
                    Navigator.pop(ctx);
                  }
                )
              )
            )
          ]
        )
      ]
    )
  );
}

Widget clientInput(ctx, client, source) {
  var personName = "${client ?? 'select'}";
  
  return Row(
    children: [
      Icon(Icons.person),
      InkWell(
        child: Row(
          children: [
            SizedBox(width: 10),
            Text("$personName", style: textLabelButton)
          ]
        ),
        onTap: () async {
          var inp = await openDialog(
            ctx,
            filteredListView(
              source,
              (filteredSource, ctx) =>
              ListView(
                children: [
                  for(var p in filteredSource)
                  ListTile(
                    onTap: () => Navigator.pop(ctx, p),
                    title: Row(
                      children: [
                        Text("$p"),
                        Expanded(
                          child: Text(
                            "${p.phoneNumber}",
                            textAlign: TextAlign.right
                          )
                        )
                      ]
                    )
                  )
                ] 
              )
            )
          );
          
          emit(cal.CalEventUpdate(client: inp));
        }
      ),
      SizedBox(width: 10),
      Text("or", style: textLabel),
      SizedBox(width: 10),
      InkWell(
        child: Text("add new", style: textLabelButton),
        onTap: () async {
          var event = await openDialog(ctx, addNewClient);

          if(event is UIEvent) {
            emit(event);
          }
        }
      ),
      SizedBox(width: 10),
      Text("client", style: textLabel)
    ]
  );
}


Widget addNewClient(ctx) {
  var nameInp = TextInp(
    labelText: "Name",
    valid: [Valid.required]
  );
  var phoneInp = TextInp(
    labelText: "Phone",
    keyboardType: TextInputType.number,
    helperText: "10 digits",
    valid: [Valid.number]
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      nameInp,
      SizedBox(height: 20),
      phoneInp,
      Expanded(
        child: SizedBox()
      ),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 35.0,
              child: ElevatedButton(
                child: Text("Add"),
                onPressed: () => Navigator.pop(ctx,
                  cal.CalEventCreateClient(
                    firstName: nameInp.inp.value!,
                    phoneNumber: phoneInp.inp.value!
                  )
                ),
              )
            )
          )
        ]
      ),
    ]
  );
}

Widget filteredListView(source, listWidget) {
  var predInp = TextInp(
    labelText: "Phone or name",
  );
  var filteredSource = ~(_) => source.where(
    (p) => p
    .toString()
    .contains(RegExp(_(predInp.inp) ?? "", caseSensitive: false))
  );

  return Column(
    children: [
      predInp,
      SizedBox(height: 15),
      Expanded(
        child: autow(listWidget, filteredSource)
      ),
    ]
  );
}


Widget timeInput(ctx, startAt) {
  return InkWell(
    onTap: () async {
      TimeOfDay? inp = await showTimePicker(
        context: ctx,
        initialTime: TimeOfDay.fromDateTime(startAt),
      );

      if(inp != null) {
        emit(cal.CalEventUpdate(startAtTime: inp));
      }
    },
    child: Text(
      "${fmt.time(startAt)}",
      style: textLabelButton
    )
  );
}

Widget durationInput(ctx, startAt, duration) {
  return InkWell(
    onTap: () async {
      var inp = await showDurationPicker(
        context: ctx,
        initialTime: duration,
      );

      emit(cal.CalEventUpdate(duration: inp));
    },
    child: Text(
      "${fmt.time(startAt.add(duration))}",
      style: textLabelButton
    )
  );
}

Widget servicesInput(ctx, eventServices, masterServices) {
  return InkWell(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          Icon(Icons.topic_outlined),
          if(eventServices.isEmpty)
          Text(
            "select services",
            style: textLabelButton
          ),
          for(var tag in eventServices)
          Chip(
            label: Text(tag.name)
          ),
        ]
      )
    ),
    onTap: () async {
      var tagsInp = ValueNotifier<BuiltSet>(eventServices);

      var inp = await openDialog(ctx,
        (ctx) => Column(
          children: [
            SizedBox(height: 40),
            selectTags(tagsInp, masterServices),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 35.0,
                    child: ElevatedButton(
                      child: Text("Add"),
                      onPressed: () => Navigator.pop(ctx, tagsInp.value),
                    )
                  )
                )
              ]
            )
          ]
        )
      );
      
      emit(cal.CalEventUpdate(services: inp));
    }
  );
}

Widget descInput(String desc) {
  var descInp = TextInp(
    value: desc,
    maxLines: 3,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    labelText: "Description",
    keyboardType: TextInputType.multiline
  );

  descInp.inp.addListener(() =>
    emit(cal.CalEventUpdate(description: descInp.inp.value))
  );
  
  return Row(
    children: [
      Expanded(
        child: descInp
      ),
    ]
  );
}

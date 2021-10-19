import 'dart:ui' as ui;
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../../utils.dart';
import '../../state.dart';
import '../../app_drawer.dart';
import '../../models/master.dart';
import '../../models.dart';
import '../../utils/rx_value.dart';
import '../../utils/ui_helpers.dart';
import './masters_working_hours_screen.dart';
import 'package:built_collection/built_collection.dart';


class MastersEditScreen extends StatelessWidget {

  const MastersEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Masters"),
        leading: BackButton(
          onPressed: () => emit(MasterEditClose()),
        )
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: formKey,
          onChanged: () {
            if(formKey.currentState != null) {
              // bool isValid = formKey.currentState?.validate();
              // if(isValid) {
              //   // var values = formKey.currentState?.values;
              //   // emit(MasterUpdate(firstName: ));
              // }
            }
          },
          child: autow(masterDetails, Masters.selected),
        )
      ),
    );
  }
}

Widget masterDetails(Master doc, ctx) {
  return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            initialValue: doc.firstName,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: "Name",
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          inputCaption(ctx, "Services"),     
          tagsInput(
            ctx,
            tags: doc.services,
            options: groupBy(AppState.services.value, (Service s) => s.cat),
          ),
          SizedBox(height: 50),
          workingHours(ctx, doc),
        ]
      ),
    )

  ;
}

Widget workingHours(ctx, Master doc) {
  return Container(
    height: 600,
    child: PageView.builder(
      itemBuilder: (ctx, page) {
        var startDate = DateRange.from(today())
        .skip(page * 7)
        .first;

        return autow((value, ctx) {
            print("render working ");
            var workingHours = Masters.masterWorkingHours7days(startDate);
            return workingHoursWeek(ctx, workingHours);
        }, Masters.onWorkingHoursUpdate);
      }
    )
  );
}

Widget tagsInput(ctx, {
    required BuiltSet<Service> tags,
    required Map options,}) {

  var selected = ValueNotifier(tags);

  Function toggle = (v) {
    if (selected.value.contains(v)) {
      selected.value = selected.value.difference({v}.build());
    } else {
      selected.value = selected.value.union(BuiltSet<Service>({v}));
    }
  };
  
  var tagsList = (selected, ctx) =>
  Wrap(
    alignment: WrapAlignment.center,
    spacing: 3.0,
    runSpacing: 4.0,
    children: [
      for(var key in options.keys)
      ...
      [
        ListTile(
          title: Container(
            alignment: Alignment.center,
            child: Text(key)
          )
        ),
        for(var v in options[key])
        InputChip(
          label: Text(v.name),
          selected: selected.contains(v),
          onPressed: () => toggle(v),
        ),
      ]
    ]
  );
  
  return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        for(var tag in tags)
        Chip(
          label: Text(tag.name)
        ),
        IconButton(
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
          onPressed: () {
            openDialog(ctx,
              autow(tagsList, selected),
              onDone: () => emit(MasterUpdate(services: selected.value))
            );
          },
          icon: Icon(Icons.edit_outlined)
        )
      ]
    )
  ;  
}

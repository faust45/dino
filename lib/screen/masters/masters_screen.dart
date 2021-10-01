import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../../utils.dart';
import '../../state.dart';
import '../../app_drawer.dart';
import '../../models/master.dart';
import '../../utils/rx_value.dart';
import '../../utils/ui_helpers.dart';


class MastersScreen extends StatelessWidget {
  const MastersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Masters")
      ),
      drawer: AppDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: autow(mastersList, AppState.masters)
      ),
    );
  }
}


Widget mastersList(masters, ctx) {
  masters = masters.toList();
  
  return ListView.builder(
    itemCount: masters.length,
    itemBuilder: (_, index) {
      Master doc = masters[index];

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            onTap: () => emit(MasterEdit(doc)),
            leading: avatar(doc),
            title: Text(doc.firstName),
          )
        )
      );
    },
  );
}


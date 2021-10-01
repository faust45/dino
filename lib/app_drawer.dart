import 'package:flutter/material.dart';
import "state.dart";

class AppDrawer extends StatelessWidget {

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
          ),
          ListTile(
            title: Text('Masters'),
            onTap: () => emit(AppPage(Pages.Masters))
          ),
          ListTile(
            title: Text('Clients'),
            onTap: () => emit(AppPage(Pages.Clients))
          ),
          ListTile(
            title: Text('Calendar'),
            onTap: () => emit(AppPage(Pages.Calendar))
          ),
          ListTile(
            title: Text('Services'),
            // onTap: () => emit([Comp.Nav], IPage.Services)
          ),
        ],
      ),
    );
  }
}

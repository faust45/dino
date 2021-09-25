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
            // onTap: () => emit([Comp.Nav], IPage.Masters)
          ),
          ListTile(
            title: Text('Clients'),
            // onTap: () => emit([Comp.Nav], IPage.Clients)
          ),
          ListTile(
            title: Text('Calendar'),
            // onTap: () => emit([Comp.Nav], IPage.Cal)
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

import 'package:flutter/material.dart';

var myDefaultBackground = Colors.grey[300];
var myAppBar = AppBar(
   iconTheme: IconThemeData(color: Colors.white),
  backgroundColor: Colors.grey[900],
);
var myDrawer = Drawer(
        surfaceTintColor: Colors.amber,
        backgroundColor: Colors.grey[300],
        child: Column(
          children: [
            DrawerHeader(child:Icon(Icons.face),
            ),
            ListTile(leading: Icon(Icons.dashboard),
            title: Text(" D A S H B O A R D"),),
            ListTile(leading: Icon(Icons.remove_red_eye_outlined),
            title: Text(" V I S I O N"),),
            ListTile(leading: Icon(Icons.person_2_outlined),
            title: Text(" A B O U T"),),
            ListTile(leading: Icon(Icons.exit_to_app),
            title: Text(" E X I T"),),
          ],
        ),
      );
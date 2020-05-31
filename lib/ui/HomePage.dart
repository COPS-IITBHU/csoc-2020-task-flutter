import 'package:flutter/material.dart';
import 'package:gmail17/ui/ComposePage.dart';
import 'package:gmail17/ui/EmailList.dart';
import 'package:gmail17/ui/FloatAppBar.dart';
import 'package:gmail17/ui/HomePageDrawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FloatAppBar(),
      body: EmailList(),
      drawer: HomePageDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComposePage(),
            ),
          );
        },
        tooltip: "Compose",
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.nordic_walking),
          title: Text("Daily Average"),
          trailing: Text('4.00'),
        ),
        ListTile(
          leading: Icon(Icons.nordic_walking),
          title: Text("Daily Average"),
          trailing: Text('4.00'),
        ),
        ListTile(
          leading: Icon(Icons.nordic_walking),
          title: Text("Daily Average"),
          trailing: Text('4.00'),
        ),
      ],
    );
  }
}

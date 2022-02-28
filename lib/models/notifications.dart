import 'package:flutter/material.dart';

import 'notif_item.dart';

class Notif {
  final Item item;

  Notif({required this.item});
}

// Demo data for our cart

List<Notif> demoNotifs = [
  Notif(item: demoItems[0]),
  Notif(item: demoItems[1]),
  Notif(item: demoItems[2]),
];

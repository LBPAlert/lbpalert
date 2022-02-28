import 'package:flutter/material.dart';

class Item {
  final String title, description;
  final Color color;

  Item({
    required this.color,
    required this.title,
    required this.description,
  });
}

// Demo notifications list

List<Item> demoItems = [
  Item(
    color: Colors.orange,
    title: "Orange Alert",
    description: "Might want to relax soon",
  ),
  Item(
    color: Colors.green,
    title: "Green Alert",
    description: "You are back in your safe spot",
  ),
  Item(
    color: Colors.red,
    title: "Red Alert",
    description: "Warning! You are at risk",
  ),
];

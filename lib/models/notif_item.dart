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

List<Item> notifications = [
  Item(
    color: Colors.grey,
    title: "Welcome to LBPAlert!",
    description: "You will receive notifications here",
  ),
];

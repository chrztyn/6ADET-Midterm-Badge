import 'package:flutter/material.dart';

// Abstract Class ToolModule
abstract class ToolModule {
  String get title;
  IconData get icon;
  Widget buildBody(BuildContext context);
}

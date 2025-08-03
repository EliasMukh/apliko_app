import 'package:flutter/material.dart';
import 'package:apliko/app.dart';
import 'package:apliko/main_config.dart';

void main() async {
  await prepareAppConfigAsync();

  runApp(const MainApp(env: 'production'));
}
//renamegf
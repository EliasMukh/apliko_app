import 'package:flutter/material.dart';
import 'package:aplico/app.dart';
import 'package:aplico/main_config.dart';

void main() async {
  await prepareAppConfigAsync();

  runApp(const MainApp(env: 'production'));
}

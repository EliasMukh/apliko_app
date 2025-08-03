// ignore_for_file: camel_case_types

import 'package:aplico/core/UI/widgets/kit.dart';

import 'package:aplico/models/kit_data.dart';
import 'package:flutter/material.dart';
import 'package:aplico/features/authentication/presentation/widgets/constants.dart';

class kit extends StatelessWidget {
  const kit({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings_input_component, color: Colors.white),
              SizedBox(width: 10),
              Text('Kit:', style: TextStyle(color: textcolor, fontSize: 23)),
            ],
          ),

          SizedBox(height: kDefaultPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                demoKitImage.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: kitCard(kitt: demoKitImage[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

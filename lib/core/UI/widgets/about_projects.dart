import 'package:apliko/models/about_project_data.dart';
import 'package:flutter/material.dart';
import 'package:apliko/features/authentication/presentation/widgets/constants.dart';

import 'package:apliko/core/UI/widgets/about_project.dart';

// ignore: camel_case_types
class aboutProject extends StatelessWidget {
  const aboutProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'About project:',
                style: TextStyle(color: textcolor, fontSize: 23),
              ),
            ],
          ),
          SizedBox(height: kDefaultPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                demoRecommendations.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: aboutProjectCard(
                    recommendation: demoRecommendations[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

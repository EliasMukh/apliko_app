// ignore_for_file: camel_case_types, use_super_parameters

import 'package:apliko/models/about_project_data.dart';
import 'package:flutter/material.dart';
import 'package:apliko/features/authentication/presentation/widgets/constants.dart';

class aboutProjectCard extends StatelessWidget {
  const aboutProjectCard({Key? key, required this.recommendation})
    : super(key: key);
  final aboutProject recommendation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(kDefaultPadding),
      color: kSecondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            // leading: CircleAvatar(
            //   radius: 30,
            //   //   backgroundImage: AssetImage(recommendation.image!),
            // ),
            title: Text(
              recommendation.name!,
              style: TextStyle(color: textcolor, fontSize: 15),
            ),
            subtitle: Text(
              recommendation.source!,
              style: TextStyle(color: textcolor, fontSize: 15),
            ),
          ),
          SizedBox(height: kDefaultPadding / 2),
          Text(
            recommendation.text!,
            maxLines: 4,
            style: TextStyle(height: 1.5, color: textcolor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

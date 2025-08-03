import 'package:apliko/models/kit_data.dart';
import 'package:flutter/material.dart';
import 'package:apliko/features/authentication/presentation/widgets/constants.dart';

// ignore: camel_case_types
class kitCard extends StatelessWidget {
  // ignore: use_super_parameters
  const kitCard({Key? key, required this.kitt}) : super(key: key);
  final kit kitt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 200,
      padding: EdgeInsets.all(kDefaultPadding),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.zero, // بدون زوايا دائرية
              child: Image.asset(
                kitt.kitImage!,
                // width: 50,
                // height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

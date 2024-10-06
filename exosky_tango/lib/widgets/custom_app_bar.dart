// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.star), // Shooting star icon
          SizedBox(width: 10),
          Text('Exosky - Tango'),
        ],
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text('Home')),
        TextButton(onPressed: () {}, child: Text('List of Planets')),
        TextButton(onPressed: () {}, child: Text('Constellation')),
        TextButton(onPressed: () {}, child: Text('Select')),
        TextButton(onPressed: () {}, child: Text('Sky View')),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0); // Define the height of the custom AppBar
}

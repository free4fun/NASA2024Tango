import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900], // Dark grey background
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align logo and text to the left
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Image.asset(
              'lib/assets/images/Tango-logo.png',
              height: 90,
            ),
          ),
          SizedBox(width: 10), // Space between logo and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10), // Add spacing from the top
              Text(
                'Terrestrial and Alien Night-sky Generator and Observer',
                style: TextStyle(
                  color: Colors.white, // White text for readability
                  fontSize: 12, // Small font for tagline
                  fontStyle: FontStyle.italic, // Optional styling
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false, // Align the title to the left
      actions: [
        // Align these options to the right
        TextButton(onPressed: () {}, child: Text('Home', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: Text('List of Planets', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: Text('Constellation', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: Text('Select', style: TextStyle(color: Colors.white))),
        TextButton(onPressed: () {}, child: Text('Sky View', style: TextStyle(color: Colors.white))),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(92.0);
}

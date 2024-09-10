// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_app/widgets/appColors.dart'; // Import your custom color class

class ForumBottom extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const ForumBottom({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.black,
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color:
                  selectedIndex == 0 ? AppColors.defaultColor : Colors.orange,
              onPressed: () => onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.add_box),
              color: selectedIndex == 1 ? Colors.orange : Colors.orange,

              onPressed: () => onItemTapped(1), // Correctly pass the index 1
            ),
            IconButton(
              icon: const Icon(Icons.person_2_sharp),
              color:
                  selectedIndex == 2 ? AppColors.defaultColor : Colors.orange,
              onPressed: () => onItemTapped(2), // Correctly pass the index 2
            ),
          ],
        ),
      ),
    );
  }
}

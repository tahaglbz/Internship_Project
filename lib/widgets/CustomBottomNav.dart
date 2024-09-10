// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/widgets/appColors.dart'; // Import your custom color class

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0, // Adjust margin for the floating button
      child: SizedBox(
        height: 60, // Adjust the height if needed
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
              icon: const Icon(Icons.cast_for_education_sharp),
              color:
                  selectedIndex == 1 ? AppColors.defaultColor : Colors.orange,
              onPressed: () => onItemTapped(1),
            ),
            CircularImageButton(
              onPressed: () {
                Get.offAllNamed('/forum');
              },
            ),
            IconButton(
              icon: const Icon(Icons.currency_exchange),
              color:
                  selectedIndex == 2 ? AppColors.defaultColor : Colors.orange,
              onPressed: () => onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.person_2_sharp),
              color:
                  selectedIndex == 3 ? AppColors.defaultColor : Colors.orange,
              onPressed: () => onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularImageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularImageButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'lib/assets/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red);
            },
          ),
        ),
      ),
    );
  }
}

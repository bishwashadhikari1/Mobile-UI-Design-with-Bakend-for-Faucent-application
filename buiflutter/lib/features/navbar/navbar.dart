import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavBarItem(Icons.home, 0),
          buildNavBarItem(Icons.auto_graph_outlined, 1),
          // buildNavBarItem(Icons.qr_code, 2),
          buildNavBarItem(Icons.show_chart, 3),
          buildNavBarItem(Icons.person, 4),
        ],
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: currentIndex == index ? 30 : 25, // adjust as needed
            child: Icon(
              icon,
              color: currentIndex == index
                  ? const Color.fromARGB(255, 23, 66, 24)
                  : const Color.fromARGB(255, 42, 41, 41),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? const Color.fromARGB(255, 23, 66, 24)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}

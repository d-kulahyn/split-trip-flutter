import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatefulWidget {
  final int currentScreen;
  final ValueChanged<int>? changeDestination;
  final List<dynamic> currencies;

  const BottomNavigation({super.key, required this.currentScreen, required this.changeDestination, required this.currencies});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 243, 255, 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -3),
            blurRadius: 5,
            spreadRadius: 0,
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentScreen,
        onTap: widget.changeDestination,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.1,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/add_group_button.svg'),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

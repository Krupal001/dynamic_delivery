import 'package:dynamic_delivery/home_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/maps/map_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:dynamic_delivery/src/features/authentication/screens/scanner/scanner_screen.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: _currentIndex);
  }

  void nextPage(int index) {
    setState(() {
      _currentIndex = index;
      controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextPage(2);
        },
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.qr_code_scanner_rounded),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index]();
        },
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: tThemeMain,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  nextPage(0);
                },
                icon: Icon(
                  Icons.history_outlined,
                  size: 35,
                  color: _currentIndex == 0 ? Colors.white : Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  nextPage(1);
                },
                icon: Icon(
                  Icons.person,
                  size: 35,
                  color: _currentIndex == 1 ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget Function()> _pages = [
        () => const HomeScreen(),
        () => const ProfileScreen(),
        () => const Scanner(),
  ];
}

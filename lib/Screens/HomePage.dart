import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';
import '../login.dart';
import '../providers/AttendenceProvider.dart';
import '../providers/BottomNavProvider.dart';
import 'AttendanceGraph.dart';
import 'HomeScreen.dart';
import 'LeavesList.dart';
import 'GrievanceList.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _bottomNavIndex = 0;
  final auth = FirebaseAuth.instance;

  final iconList = <IconData>[
    Icons.home,
    Icons.school,
    Icons.person,
    Icons.book_online_sharp,
  ];
  @override
  void initState() {
    Provider.of<AttendanceService>(context, listen: false).fetchcheckOut();
    Provider.of<AttendanceService>(context, listen: false).fetchcheckIn();
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    const LeavesPage(),
    AttendanceGraph(),
    const GrievancesList(),
  ];
  @override
  Widget build(BuildContext context) {
    var selectedIndex = Provider.of<BottomNavProvider>(context).selectetab;

    String getheader() {
      if (selectedIndex == 0) {
        return 'Nester';
      } else if (selectedIndex == 1) {
        return 'Leaves';
      } else if (selectedIndex == 2) {
        return 'Graph Attendance';
      }
      return 'Grievances Response';
    }

    Future<LoginPage> signOut() async {
      await FirebaseAuth.instance.signOut();

      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(getheader()),
        actions: [
          InkWell(
              onTap: () {
                signOut();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(
                  Icons.logout_sharp,
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: _pages.elementAt(selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(iconList[_bottomNavIndex],
            color: Theme.of(context).colorScheme.primary),
        onPressed: () {},
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) => setState(() {
          Provider.of<BottomNavProvider>(context, listen: false).select(index);
          _bottomNavIndex = index;
        }),
        //other params
      ),
    );
  }
}

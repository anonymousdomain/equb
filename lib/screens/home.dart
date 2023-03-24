import 'package:equb/widget/nav_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController? _pageController;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
  }

  onPageChanged(int page) {
    setState(() {
      pageIndex = page;
    });
  }

  onPageTap(int page) {
    _pageController!.animateToPage(page,
        duration: Duration(microseconds: 200), curve: Curves.linearToEaseOut);
  }

  @override
  void dispose() {

    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('welcome home'),
      ),
      drawer: NavDrawer(),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          Center(
            child: Text('1'),
          ),
          Center(child: Text('2')),
          Center(
            child: Text('3'),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: onPageTap,
        currentIndex: pageIndex,
        activeColor: Colors.indigo
        ,items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.star,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.edit_note,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
          Icons.deblur,
          size: 30,
        ))
      ]),
    );
  }
}

import 'package:equb/helper/firbasereference.dart';
import 'package:equb/models/user.dart';
import 'package:equb/screens/equbGroup/equb_groups.dart';
import 'package:equb/screens/equbGroup/equbs_in.dart';
import 'package:equb/screens/equbGroup/requested_groups.dart';
import 'package:equb/screens/onhome.dart';
import 'package:equb/widget/nav_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../service/search.dart';
import '../service/services.dart';
import '../widget/custom_snackbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController? _pageController;
  int pageIndex = 0;
  User? _user;
  @override
  void initState() {
    super.initState();
    _loadProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBar(
                duration: Duration(seconds: 3),
                message: 'You are logged in successfuly',
                isSuccess: true))));

    _pageController = PageController(initialPage: pageIndex);
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
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

  Widget customContainer() {
    return Container(
      child: _user?.role == 'admin' ? GroupRequest() : NewEqubGroup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            // color: Colors.blue,
              onPressed: () {

                showSearch(context: context, delegate: GroupSearch());
              },
              icon: Icon(FeatherIcons.search)),
          IconButton(onPressed: () {}, icon: Icon(FeatherIcons.bell))
        ],
      ),
      drawer: NavDrawer(),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          OnHome(),
          GroupsIn(),
          // NewEqubGroup(),
          customContainer(),
          Center(
            child: Text('new stuf'),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
          onTap: onPageTap,
          currentIndex: pageIndex,
          activeColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.home,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.droplet,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.userPlus,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
              FeatherIcons.anchor,
              size: 30,
            ))
          ]),
    );
  }
}

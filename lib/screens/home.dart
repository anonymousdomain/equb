import 'package:equb/models/user.dart';
import 'package:equb/screens/equbGroup/equb_groups.dart';
import 'package:equb/screens/equbGroup/equbs_in.dart';
import 'package:equb/screens/equbGroup/requested_groups.dart';
import 'package:equb/screens/notification/equb_notification.dart';
import 'package:equb/screens/onhome.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/nav_drawer.dart';
import 'package:equb/widget/notification_bell.dart';
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
  int? notificationCount;
  @override
  void initState() {
    super.initState();
    _loadProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomSnackBar(
                duration: Duration(seconds: 3),
                message: 'welcome back',
                isSuccess: true))));

    _pageController = PageController(initialPage: pageIndex);
    _countNotification();
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  void _countNotification() async {
    notificationCount = await notify();
    print(notificationCount);
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
          IconButton(
              onPressed: () {},
              icon: NotificationBell(
                notificationCount: notificationCount ?? 0,
              ))
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
          EqubNotification()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
          onTap: onPageTap,
          currentIndex: pageIndex,
          activeColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                FeatherIcons.home,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Groups',
              icon: Icon(
                FeatherIcons.package,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'GroupRequests',
              icon: Icon(
                FeatherIcons.gitPullRequest,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
                label: 'Notification',
                icon: Icon(
                  FeatherIcons.bell,
                  size: 30,
                ))
          ]),
    );
  }
}

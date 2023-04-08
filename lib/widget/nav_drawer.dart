import 'package:equb/models/user.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/screens/equbGroup/equb_groups.dart';
import 'package:equb/service/services.dart';
import 'package:equb/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  User? _user;
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    _user = await getUserDocument();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: _user == null
                ? ListTile(
                    leading: CircleAvatar(
                    radius: 30,
                    child: CircularProgressIndicator(),
                  ))
                : ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(_user!.imageUrl ?? ''),
                      child: _user == null
                          ? Icon(
                              FeatherIcons.user,
                            )
                          : SizedBox.shrink(),
                    ),
                    title: Text('${_user?.firstName} ${_user?.lastName}'),
                    subtitle: Text(
                      _user?.phoneNumber ?? '',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                    trailing: GestureDetector(
                      child: currentTheme.currentTheme == ThemeMode.dark
                          ? Icon(FeatherIcons.moon)
                          : Icon(FeatherIcons.sun),
                      onTap: () => currentTheme.toggleTheme(),
                    ),
                  ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
            leading: Icon(FeatherIcons.home),
          ),
          ListTile(
            title: Text('Equbs'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Text('hello')))),
            leading: Icon(FeatherIcons.umbrella),
          ),
          ListTile(
            title: Text('Join'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => NewEqubGroup()))),
            leading: Icon(FeatherIcons.plusCircle),
          ),
          ListTile(
            leading: Icon(FeatherIcons.logOut),
            title: Text('Logout'),
            onTap: () =>
                Provider.of<AuthState>(context, listen: false).signOut(),
          )
        ],
      ),
    );
  }
}

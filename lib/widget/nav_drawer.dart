import 'package:equb/models/user.dart';
import 'package:equb/provider/auth_state.dart';
import 'package:equb/screens/edit_profile.dart';
import 'package:equb/screens/equbGroup/equb_groups.dart';
import 'package:equb/screens/equbGroup/equbs_in.dart';
import 'package:equb/screens/equbGroup/new_equb_group.dart';
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
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: _user == null
                ? ListTile(
                    leading: CircleAvatar(
                    radius: 30,
                    child: CircularProgressIndicator(),
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditProfile(user: _user,)))),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(_user!.imageUrl ?? ''),
                            child: _user == null
                                ? Icon(
                                    FeatherIcons.user,
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                        title: Text('${_user?.firstName} ${_user?.lastName}'),
                        subtitle: Text(
                          _user?.phoneNumber ?? '',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                        trailing: GestureDetector(
                          child: currentTheme.currentTheme == ThemeMode.dark
                              ? Icon(FeatherIcons.moon)
                              : Icon(FeatherIcons.sun),
                          onTap: () => currentTheme.toggleTheme(),
                        ),
                        // isThreeLine: true,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Id:${_user?.id}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
            leading: Icon(FeatherIcons.home),
          ),
          _user?.role == 'admin'
              ? ListTile(
                  title: Text('New'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewEqub())),
                  leading: Icon(FeatherIcons.plusCircle),
                )
              : SizedBox.shrink(),
          ListTile(
            title: Text('Equbs'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => GroupsIn()),
              ),
            ),
            leading: Icon(FeatherIcons.droplet),
          ),
          ListTile(
            title: Text('Join'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => NewEqubGroup()),
              ),
            ),
            leading: Icon(FeatherIcons.userPlus),
          ),
          ListTile(
            leading: Icon(FeatherIcons.lock),
            title: Text('Logout'),
            onTap: () =>
                Provider.of<AuthState>(context, listen: false).signOut(),
          )
        ],
      ),
    );
  }
}

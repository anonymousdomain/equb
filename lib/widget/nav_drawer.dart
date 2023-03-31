import 'package:equb/provider/auth_state.dart';
import 'package:equb/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  FeatherIcons.user,
                ),
              ),
              title: Text('dawit yitagesu'),
              subtitle: Text('+251915559055' ,style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),),
              trailing: GestureDetector(
                child: currentTheme.currentTheme == ThemeMode.dark
                    ? Icon(FeatherIcons.moon)
                    : Icon(FeatherIcons.sun),
                onTap: () => currentTheme.toggleTheme(),
              ),
            ),
          ),
          ListTile(
            title: Text('home'),
            onTap: () => Navigator.pop(context),
            leading: Icon(FeatherIcons.home),
          ),
          ListTile(
            title: Text('equbs You joind in'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Text('hello')))),
            leading: Icon(FeatherIcons.umbrella),
          ),
          ListTile(
            leading: Icon(FeatherIcons.logOut),
            title: Text('logout'),
            onTap: () =>
                Provider.of<AuthState>(context, listen: false).signOut(),
          )
        ],
      ),
    );
  }
}

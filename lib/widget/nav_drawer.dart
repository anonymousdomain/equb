import 'package:equb/provider/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('hello'),
          ),
          ListTile(
            title: Text('posts'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Text('hello')))),
          ),
          ListTile(
            title: Text('signOut'),
            onTap: () => Provider.of<AuthState>( context,listen: false).signOut(),
          )
        ],
      ),
    );
  }
}

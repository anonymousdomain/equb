import 'package:flutter/material.dart';

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
          )
        ],
      ),
    );
  }
}

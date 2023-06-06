import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class NotificationBell extends StatelessWidget {
  NotificationBell({super.key,required this.notificationCount});
  final int notificationCount;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //bell icon
        Icon(
          FeatherIcons.bell,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              notificationCount.toString(),
              style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

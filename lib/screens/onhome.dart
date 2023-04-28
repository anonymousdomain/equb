import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:equb/service/group.dart';
import 'package:equb/widget/employee_catagory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

import 'equbGroup/equbs_in.dart';

class OnHome extends StatefulWidget {
  const OnHome({super.key});

  @override
  State<OnHome> createState() => _OnHomeState();
}

class _OnHomeState extends State<OnHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            title: Text('WELCOME TO ADDIS EQUB'),
          ),
          SliverToBoxAdapter(
           child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              EmployeeCard(),
            ],
           ),
          )
        ],
      ),
    );
  }
}

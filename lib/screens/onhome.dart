import 'package:equb/helper/images.dart';
import 'package:equb/widget/employee_catagory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(Images.life),
              titlePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  'WELCOME TO ADDIS EQUB',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15),
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'EMPLOYEE EQUB',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                EmployeeCard(query: 'Employee'),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Drivers EQUB',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                EmployeeCard(query: 'Drivers'),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Bussiness EQUB',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                EmployeeCard(query: 'Bussiness')
              ],
            ),
          )
        ],
      ),
    );
  }
}

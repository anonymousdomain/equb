import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
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
  List<String> categories = [
    'Drivers',
    'Employee',
    'Trending',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: groupCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Widget> slivers = [];
          for (DocumentSnapshot doc in snapshot.data!.docs) {
            String catagory = doc['catagory'];
            if (categories.contains(catagory)) {
              slivers.add(
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: ((context, index) {
                            return Container(
                              width: 160,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text('Item ${index + 1}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('Category: $catagory',
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 4),
                                    Text('Description of Item ${index + 1}',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('MultipleScrolling Experince'),
              ),
              ...slivers
            ],
          );
        },
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       title: Text('MultipleScrolling Experince'),
      //     ),
      //     for (String category in categories)
      //       SliverToBoxAdapter(
      //         child: Column(
      //           children: [
      //             SizedBox(height: 8),
      //             Container(
      //               height: 200,
      //               child: ListView.builder(
      //                 scrollDirection: Axis.horizontal,
      //                 itemCount: 20,
      //                 itemBuilder: ((context, index) {
      //                   return Container(
      //                     width: 160,
      //                     margin: EdgeInsets.symmetric(horizontal: 8),
      //                     child: Card(
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           SizedBox(height: 8),
      //                           Text('Item ${index + 1}',
      //                               style: TextStyle(
      //                                   fontSize: 18,
      //                                   fontWeight: FontWeight.bold)),
      //                           SizedBox(height: 4),
      //                           Text('Category: $category',
      //                               style: TextStyle(fontSize: 14)),
      //                           SizedBox(height: 4),
      //                           Text('Description of Item ${index + 1}',
      //                               style: TextStyle(fontSize: 14)),
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 }),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}

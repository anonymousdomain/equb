import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equb/helper/firbasereference.dart';
import 'package:flutter/material.dart';

class OnHome extends StatefulWidget {
  const OnHome({super.key});

  @override
  State<OnHome> createState() => _OnHomeState();
}

class _OnHomeState extends State<OnHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: groupCollection.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<DocumentSnapshot> docs = snapshot.data!.docs;
            return GridView.builder(
              scrollDirection:Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, childAspectRatio: 1.0),
                itemBuilder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      borderOnForeground: true,
                      margin: EdgeInsets.all(10),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                });
          }),
    );
  }
}

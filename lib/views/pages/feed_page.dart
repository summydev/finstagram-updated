import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finstagram/model/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: _deviceHeight,
      width: _deviceWidth,
      child: _ListPosts(),
    );
  }

  Widget _ListPosts() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getLatestPosts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List posts =snapshot.data!.docs.map((e)=>e.data()).toList();
            return ListView.builder(itemCount: posts.length, itemBuilder: (BuildContext context, int index) {
              Map post = posts[index];
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: _deviceHeight! * 0.01,
                    horizontal: _deviceWidth! * 0.05
                ),
                height: _deviceHeight! * 0.30,
                decoration: BoxDecoration(

                    image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(
                      post["image"],

                    ))
                ),
              );
            },);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        });
  }
}

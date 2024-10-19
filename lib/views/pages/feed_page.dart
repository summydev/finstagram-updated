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
      child: _listPosts(),
    );
  }

  Widget _listPosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService!.getLatestPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Map post = posts[index];
              return _postCard(post);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
      },
    );
  }

  Widget _postCard(Map post) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firebaseService!.getUserById(post["userId"]),
      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (userSnapshot.hasData) {
          var user = userSnapshot.data!.data() as Map<String, dynamic>;
          return Card(
            margin: EdgeInsets.symmetric(
              vertical: _deviceHeight! * 0.01,
              horizontal: _deviceWidth! * 0.05,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user["image"] ?? 'https://via.placeholder.com/150', // Fallback image
                    ),
                  ),
                  title: Text(
                    user["name"] ?? "Unknown User", // Fallback username
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _formatTimestamp(post["timestamp"] ?? Timestamp.now()), // Fallback timestamp
                  ),
                ),
                Container(
                  height: _deviceHeight! * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(post["image"] ?? 'https://via.placeholder.com/300'), // Fallback post image
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    post["caption"] ?? "No caption available", // Fallback caption
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _likeButton(),
                      const Icon(Icons.comment, color: Colors.grey),
                      const Icon(Icons.share, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _likeButton() {
    return IconButton(
      icon: const Icon(Icons.favorite_border, color: Colors.red),
      onPressed: () {
        // Handle like button functionality
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}

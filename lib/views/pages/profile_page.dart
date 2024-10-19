// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finstagram/model/services/service.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
//
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   FirebaseService? _firebaseService;
//   double? _deviceHeight, _deviceWidth;
//
//   @override
//   void initState() {
//
//     super.initState();
//     _firebaseService = GetIt.instance.get<FirebaseService>();
//   }
//   @override
//   Widget build(BuildContext context) {
//     _deviceWidth =MediaQuery.of(context).size.width;
//     _deviceHeight =MediaQuery.of(context).size.height;
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: _deviceWidth! * 0.05,
//           vertical: _deviceHeight! * 0.02
//       ),
//
//       color: Colors.orange,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _profileImage(),_postGridView()
//         ],
//
//       ),
//     );
//   }
//   Widget _profileImage(){
//     return Container(
//       margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
//       height: _deviceHeight! * 0.15,
//       width: _deviceHeight! * 0.15,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100.0),
//           image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(_firebaseService!.currentUser!["image"]))
//       ),
//     );
//   }
//   Widget _postGridView(){
//     return Expanded(child:
//     StreamBuilder<QuerySnapshot>(stream: _firebaseService!.getPostForUser(), builder: (BuildContext context, AsyncSnapshot snapshot) {
//       if(snapshot.hasData){
//         List posts = snapshot.data!.docs.map((e)=> e.data()).toList();
//         return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
//             itemCount: posts.length,
//             itemBuilder: (context, index){
//               Map post = posts[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage( fit: BoxFit.cover, image: NetworkImage(post["image"],),),
//                 ),
//               );
//
//             });
//       }else{
//
//         return const Center(
//           child: CircularProgressIndicator(
//             color: Colors.red,
//           ),
//         );
//       }
//
//
//     },)
//     );
//
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finstagram/model/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
            vertical: _deviceHeight! * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _profileHeader(),
              SizedBox(height: 20),
              Expanded(child: _postGridView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        _profileImage(),
        SizedBox(height: 10),
        _userName(),
        SizedBox(height: 5),
        _userDescription(),
      ],
    );
  }

  Widget _profileImage() {
    return CircleAvatar(
      radius: _deviceHeight! * 0.075,
      backgroundImage: NetworkImage(_firebaseService!.currentUser!["image"]),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _userName() {
    return Text(
      _firebaseService!.currentUser!["name"] ?? "User Name",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _userDescription() {
    return Text(
      _firebaseService!.currentUser!["description"] ?? "Welcome to my profile!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _postGridView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService!.getPostForUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Map post = posts[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(post["image"]),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }
}

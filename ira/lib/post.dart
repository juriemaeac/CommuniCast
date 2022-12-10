// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ira/auth/auth.dart';
// import 'package:ira/model/user.dart';
// import 'package:provider/provider.dart';

// class Post extends StatefulWidget {
//   final String postId;
//   final String ownerId;
//   final String username;
//   final String location;
//   final String description;
//   final String mediaUrl;
//   final dynamic likes;

//   Post({
//     required this.postId,
//     required this.ownerId,
//     required this.username,
//     required this.location,
//     required this.description,
//     required this.mediaUrl,
//     required this.likes,
//   });

//   factory Post.fromDocument(DocumentSnapshot doc) {
//     return Post(
//       postId: doc['postId'],
//       ownerId: doc['ownerId'],
//       username: doc['username'],
//       location: doc['location'],
//       description: doc['description'],
//       mediaUrl: doc['mediaUrl'],
//       likes: doc['likes'],
//     );
//   }

//   int getLikeCount() {
//     if (likes == null) {
//       return 0;
//     }
//     int count = 0;
//     likes.values.forEach((val) {
//       if (val == true) {
//         count += 1;
//       }
//     });
//     return count;
//   }

//   @override
//   State<Post> createState() => _PostState(
//         postId: this.postId,
//         ownerId: this.ownerId,
//         username: this.username,
//         location: this.location,
//         description: this.description,
//         mediaUrl: this.mediaUrl,
//         likes: this.likes,
//         likeCount: getLikeCount(),
//       );
// }

// class _PostState extends State<Post> {
//   final String postId;
//   final String ownerId;
//   final String username;
//   final String location;
//   final String description;
//   final String mediaUrl;
//   int likeCount;
//   Map likes;

//   _PostState({
//     required this.postId,
//     required this.ownerId,
//     required this.username,
//     required this.location,
//     required this.description,
//     required this.mediaUrl,
//     required this.likes,
//     required this.likeCount,
//   });

//   // getUserData() async {
//   //   final user = context.read<User?>();
//   //   final userData = await FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(user!.uid)
//   //       .get();
//   //   setState(() {
//   //     username = userData['username'];
//   //     email = userData['email'];
//   //     firstName = userData['firstName'];
//   //     lastName = userData['lastName'];
//   //   });
//   // }

//   buildPostHeader() {
//     return FutureBuilder(
//       future: usersRef.doc(ownerId).get(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         //get current user id
//         final currentUser = context.read<User?>();

//         User user = User.fromDocument(snapshot.data);

//         bool isPostOwner = currentUser == ownerId;
//         return ListTile(
//           // leading: CircleAvatar(
//           //   backgroundImage: NetworkImage(user.photoUrl),
//           //   backgroundColor: Colors.grey,
//           // ),
//           title: GestureDetector(
//             onTap: () => print('showing profile'),
//             child: Text(
//               user.username,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           subtitle: Text(location),
//           trailing: isPostOwner
//               ? IconButton(
//                   icon: Icon(Icons.more_vert),
//                   onPressed: () => print('deleting post'),
//                 )
//               : Text(''),
//         );
//       },
//     );
//   }

//   buildPostImage() {
//     return GestureDetector(
//       onDoubleTap: () => print('liking post'),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Image.network(mediaUrl),
//         ],
//       ),
//     );
//   }

//   buildPostFooter() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 40.0, left: 20.0),
//             ),
//             GestureDetector(
//               onTap: () => print('liking post'),
//               child: Icon(
//                 Icons.favorite_border,
//                 size: 28.0,
//                 color: Colors.pink,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 20.0),
//             ),
//             GestureDetector(
//               onTap: () => print('showing comments'),
//               child: Icon(
//                 Icons.chat,
//                 size: 28.0,
//                 color: Colors.blue[900],
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 20.0),
//               child: Text(
//                 '$likeCount likes',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 20.0),
//               child: Text(
//                 '$username',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 description,
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         buildPostHeader(),
//         Divider(
//           color: Colors.grey,
//         ),
//         buildPostImage(),
//         buildPostFooter(),
//       ],
//     );
//   }
// }

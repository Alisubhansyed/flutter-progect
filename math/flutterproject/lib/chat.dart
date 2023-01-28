import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Chat/chatWidget/SearchField.dart';
import 'ChatTile.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  String myemail = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.9,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "Message",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          // color: Colors.amber,
          padding: EdgeInsets.all(0),
          height: height,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(myemail + "message")
                  .snapshots(),
              builder: (context, snapshot) {
                List<int> numderOfmessage = [];
                List<String> user = [];

                List<String> email = [];
                List<String> time = [];
                if (snapshot.hasData) {
                  final datum = snapshot.data!.docs;
                  for (var data in datum) {
                    if (data.data()["email"] != myemail) {
                      user.add(data.data()["user"]);
                      email.add(data.data()["email"]);
                      numderOfmessage.add(data.data()["numderOfMessage"]);
                      time.add(data.data()["time"].toString());
                    }
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Color.fromARGB(255, 170, 169, 164),
                      // height: 2,
                    ),
                    itemCount: user.length,
                    itemBuilder: (context, index) {
                      return ChatTitle(
                        user: user[index],
                        email: email[index],
                        time: time[index],
                        previousNumder: numderOfmessage[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepOrange,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
///////////////////////////////////
///
///
///
///
///
///
// import 'package:flutter/material.dart';

// import 'Chat/chatWidget/SearchField.dart';
// import 'ChatTile.dart';

// class ChatApp extends StatefulWidget {
//   const ChatApp({super.key});

//   @override
//   State<ChatApp> createState() => _ChatAppState();
// }

// class _ChatAppState extends State<ChatApp> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: Text(
//             "Message",
//             style: TextStyle(color: Colors.black),
//           ),
//           centerTitle: false,
//           elevation: 0,
//           bottom: PreferredSize(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     // height: height / 4,
//                     // color: Colors.amber,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: Color.fromARGB(255, 219, 230, 235),
//                       ),
//                       height: 50,
//                       margin: EdgeInsets.all(20),
//                       child: SearchField(),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Text(
//                         "Activites",
//                         style: TextStyle(fontSize: 17),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                     height: 100,
//                     child: ListView.builder(
//                       itemCount: 10,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.only(right: 10),
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: 30,
//                                 child: CircleAvatar(
//                                   radius: 27,
//                                   backgroundColor: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "data",
//                                 style: TextStyle(fontSize: 17),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(15, 0, 0, 10),
//                     child: Text(
//                       "Messages",
//                       style: TextStyle(fontSize: 17),
//                     ),
//                   )
//                 ],
//               ),
//               preferredSize: Size(double.infinity, height / 3)),
//         ),
//         body: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           // color: Colors.amber,
//           padding: EdgeInsets.all(0),
//           height: height,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => Divider(
//               color: Color.fromARGB(255, 170, 169, 164),
//               // height: 2,
//             ),
//             itemCount: 10,
//             itemBuilder: (context, index) {
//               return ChatTitle();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/ChatScreen.dart';
import 'package:intl/intl.dart';

class ChatTitle extends StatefulWidget {
  ChatTitle(
      {required this.user,
      required this.email,
      required this.time,
      required this.previousNumder});
  final String user;
  final String email;
  final String time;
  final int previousNumder;

  @override
  State<ChatTitle> createState() => _ChatTitleState();
}

class _ChatTitleState extends State<ChatTitle> {
  int numderOfUnreadMessage = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(widget.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data();
            String imageUrl = "";
            String name = "";

            try {
              imageUrl = data!["urlProfile"].toString();

              name = data["name"].toString();
            } catch (e) {
              print(e);
            }

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.user)
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final datum = snapshot.data!.docs;
                    int messagelenght =
                        datum.length - (widget.previousNumder + 1);
                    String? lastMessage =
                        datum[datum.length - 1].data()["messageData"];
                    print(messagelenght);
                    print(datum.length);
                    print(widget.previousNumder);
                    // print(lastMessage);

                    return Container(
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection(
                                  "${_auth.currentUser!.email}" + "message")
                              .doc(widget.email)
                              .update({
                            "numderOfMessage": datum.length - 1,
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(widget.email)));
                        },
                        contentPadding: EdgeInsets.all(0),
                        // horizontalTitleGap: 0,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) {
                              return Container(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        // child: CircleAvatar(
                        //   radius: 25,
                        //   backgroundColor: Colors.amber,
                        // ),

                        trailing: Column(
                          children: [
                            Text(
                              DateFormat('hh:mm a')
                                  .format(DateTime.parse(widget.time)),
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: messagelenght == 0
                                  ? Colors.transparent
                                  : Colors.deepOrange,
                              radius: 10,
                              child: messagelenght == 0
                                  ? null
                                  : Text(
                                      messagelenght.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                            )
                          ],
                        ),
                        title: Text(name),
                        subtitle:
                            lastMessage != null ? Text(lastMessage) : Text(''),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          } else {
            return Container();
          }
        });
  }
}

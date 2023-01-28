import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.yourEmail);
  final String yourEmail;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String myemail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    TextEditingController message = TextEditingController();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: StreamBuilder(
            stream: status.getStatus(widget.yourEmail),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data();
                String oStarus = '';
                DateTime staustime = DateTime.parse(
                  data!["timeOfStatus"],
                );
                if (DateFormat('dd MMMM yyyy hh:mm a').format(staustime) ==
                    DateFormat('dd MMMM yyyy hh:mm a').format(DateTime.now())) {
                  oStarus = "online";
                } else {
                  oStarus =
                      DateFormat('dd MMMM yyyy hh:mm a').format(staustime);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: data["name"] != null
                            ? Text(data["name"])
                            : CircularProgressIndicator()),
                    Text(
                      oStarus,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                );
              } else {
                return Container();
              }
            }),
        elevation: 0.9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(myemail + widget.yourEmail)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              List<String> messages = [];
              List<String> imageurl = [];
              List<String> time = [];
              List<String> mail = [];
              List<String> name = [];

              if (snapshot.hasData) {
                final datum = snapshot.data!.docs;
                for (var data in datum) {
                  messages.add(data.data()["messageData"]);
                  imageurl.add(data.data()['url']);
                  time.add(data.data()['time'].toString());
                  mail.add(data.data()['email']);
                  name.add(data.data()['name']);
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages != 0
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                // color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: ListTile(
                                leading: Container(
                                  height: 35,
                                  width: 35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: imageurl[index],
                                      placeholder: (context, url) {
                                        return Container(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                title: Text.rich(TextSpan(children: [
                                  TextSpan(text: "${name[index]} "),
                                  TextSpan(
                                      text: DateFormat('dd MMMM yyyy').format(
                                              DateTime.parse(time[index])) +
                                          " " +
                                          DateFormat('hh:mm a').format(
                                              DateTime.parse(time[index])),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ])),
                                subtitle: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.shade100,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                      topLeft: Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    messages[index],
                                  ),
                                ),
                                isThreeLine: true,
                              ),
                              // height: 50,
                              width: 100,
                              // color: Colors.amber,
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width / 1.3,
                          child: TextFormField(
                            controller: message,
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                              enabled: true,
                              hintText: "Message...",
                              focusColor: Colors.deepOrange,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(50),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepOrange),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            // firestore
                            //     .collection(widget.yourEmail + "message")
                            //     .doc(myemail)
                            //     .set({
                            //   'user': myemail + widget.yourEmail,
                            //   'email': myemail,
                            //   "time": DateTime.now().toString(),
                            //   "numderOfMessage": snapshot.data!.docs.length,
                            // });

                            await firestore
                                .collection("user")
                                .doc(myemail)
                                .get()
                                .then((value) {
                              // .add({'user': myemail + widget.yourEmail});

                              firestore
                                  .collection(myemail + widget.yourEmail)
                                  .add({
                                "messageData": message.value.text,
                                "time": DateTime.now().toString(),
                                "email": myemail,
                                "url": value.data()!['urlProfile'],
                                'name': value.data()!['name'],
                              }).then((value) {
                                firestore
                                    .collection(myemail + "message")
                                    .doc(widget.yourEmail)
                                    .set({
                                  'user': myemail + widget.yourEmail,
                                  'email': widget.yourEmail,
                                  "time": DateTime.now().toString(),
                                  "numderOfMessage": snapshot.data!.docs.length,
                                });
                              });

                              firestore
                                  .collection(widget.yourEmail + myemail)
                                  .add({
                                "messageData": message.value.text,
                                "time": DateTime.now().toString(),
                                "email": myemail,
                                "url": value.data()!['urlProfile'],
                                'name': value.data()!['name'],
                              }).then((value) {});
                            });

                            message.clear();
                          },
                          backgroundColor: Colors.deepOrange,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

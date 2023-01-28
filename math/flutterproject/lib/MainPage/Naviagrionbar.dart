import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/MainPage/mainPage.dart';
import 'package:flutterproject/constant.dart';
import 'package:flutterproject/model.dart';

import '../AddItem/Add.dart';
import '../chat.dart';
import '../main.dart';

class NAV extends StatefulWidget {
  const NAV({super.key});

  @override
  State<NAV> createState() => _NAVState();
}

class _NAVState extends State<NAV> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int index = 0;
  List screen = [MyHomePage(), Add(), ChatApp(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index],
      bottomNavigationBar: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        elevation: 20,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              backgroundColor: Colors.white,
              // iconSize: 30,
              selectedIconTheme: IconThemeData(color: Colors.deepOrange),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedIconTheme:
                  IconThemeData(color: Color.fromARGB(255, 197, 196, 196)),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(
                    Icons.home_outlined,
                    // color: Color.fromARGB(255, 206, 206, 206),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Add",
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    // size: 45,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Chat",
                  icon: Icon(
                    CupertinoIcons.chat_bubble,
                    // color: Color.fromARGB(255, 206, 206, 206),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(
                    Icons.person_outline_rounded,
                    // color: Color.fromARGB(255, 206, 206, 206),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("itemsForSell").snapshots(),
        builder: (context, snapshot) {
          List<String> name = [];
          List<String> barnd = [];
          List<String> nameAndBarnd = [];

          if (snapshot.hasData) {
            final datum = snapshot.data!.docs;

            for (var data in datum) {
              name.add(
                data.data()["title"].toString().trim(),
              );
              barnd.add(data.data()["band"].toString().trim());
            }
            nameAndBarnd = name + barnd;

            print(nameAndBarnd.toSet().toList());

            return IconButton(
                color: Colors.black,
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate:
                        CustomSearchDeligate(nameAndBarnd.toSet().toList()),
                  );
                },
                icon: Icon(Icons.search));
          } else {
            return Container();
          }
        });
  }
}

class CustomSearchDeligate extends SearchDelegate {
  CustomSearchDeligate(this.searchResult);

  final List<String> searchResult;
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return DisplayItembuilder(
      text: query,
      // query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResult.toSet().toList().where((element) {
      final result = element.toLowerCase();
      final input = query.toLowerCase();
      return result.startsWith(input);
    }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return Card(
          child: ListTile(
            title: Text(suggestion),
            onTap: (() {
              query = suggestion;
              showResults(context);
            }),
          ),
        );
      },
    );
  }
}

class Profile extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(_auth.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              String name = data?.data()!['name'];
              String urlProfile = data?.data()!['urlProfile'];

              return Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: urlProfile,
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
                        title: Text(
                          name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text("I am $name ."),
                      ),
                    ),
                    KHSpace(20),
                    ProfileTile(
                      icon: Icons.email_outlined,
                      title: _auth.currentUser!.email.toString(),
                    ),
                    ProfileTile(
                      icon: Icons.phone,
                      title: "03XX XXXXXXX",
                    ),
                    GestureDetector(
                        onTap: () {
                          _auth.signOut();
                        },
                        child: ProfileTile(
                          icon: Icons.power_settings_new_outlined,
                          title: 'LogOut',
                        )),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              );
            }
          }),
    );
  }
}

class ProfileTile extends StatelessWidget {
  ProfileTile({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          leading: Icon(
            icon,
            color: icon == Icons.power_settings_new_outlined
                ? Colors.deepOrange
                : Colors.deepOrange.shade200,
          ),
          title: Text(
            title,
            style: TextStyle(color: Color.fromARGB(255, 133, 132, 131)),
          ),
        ),
      ],
    );
  }
}

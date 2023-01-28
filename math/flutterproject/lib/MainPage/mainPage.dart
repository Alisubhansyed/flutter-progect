import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterproject/MainPage/Naviagrionbar.dart';
import 'package:flutterproject/main.dart';
import 'package:flutterproject/model.dart';
import 'package:path/path.dart';
import '../constant.dart';
import '../rowText.dart';
import 'ChipsSelect.dart';
import 'Gridwidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore fireGet = FirebaseFirestore.instance;
  loadingItems() {
    fireGet.collection("itemsForSell").get();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  String profileImageUrl = '';
  String nameOfPerson = '';

  @override
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    List<String> adImages = [
      "https://www.sendiancreations.com/wp-content/uploads/2019/12/The-difference-between-advertising-and-marketing-1024x683.jpg",
      "https://static-cse.canva.com/blob/835441/create_ad-maker_how-to.jpg",
      "https://s3-prod.adage.com/s3fs-public/styles/width_660/public/aa-w3mt2023_3x2_logo.jpg",
    ];

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            KHSpace(30),
            StreamBuilder(
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
          ],
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("user")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.data()!["name"],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                );
              } else {
                return Text("kk ");
              }
            }),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                CupertinoIcons.equal,
                color: Colors.black,
                size: 30,
              ));
        }),
        backgroundColor: Colors.white,
        elevation: 0.9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [Search()],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              KHSpace(5),
              AspectRatio(
                aspectRatio: 5 / 3,
                child: Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CarouselSlider(
                        items: adImages.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: i,
                                  placeholder: (context, url) {
                                    return Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        carouselController: _controller,
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            aspectRatio: 5 / 3,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: adImages.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 10.0,
                                  height: 10.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.deepOrange.shade100
                                              : Colors.deepOrange.shade200)
                                          .withOpacity(_current == entry.key
                                              ? 0.9
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              KHSpace(20),
              TextRow(
                mainTXt: "Urgent Selling",
                secTXt: "See All",
                secRouting: () {},
              ),
              KHSpace(20),
              Container(
                height: 105,
                width: double.infinity,
                child: PromotionDisplayBuilder(),
              ),
              KHSpace(10),
              TextRow(
                mainTXt: "All Products",
                secTXt: "See All",
                secRouting: () {},
              ),
              KHSpace(10),
              Center(
                  child: DisplayItembuilder(
                text: null,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionDisplayBuilder extends StatelessWidget {
  const PromotionDisplayBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("promotion").snapshots(),
        builder: (context, snapshot) {
          List<String> title = [];
          List<String> price = [];
          List<String> brand = [];
          List<String> address = [];
          List<String> decription = [];
          List<String> urlImage = [];
          List<String> email = [];

          if (snapshot.hasData) {
            final datum = snapshot.data!.docs;
            for (var data in datum) {
              title.add(data.data()["title"]);
              price.add(data.data()["price"]);
              brand.add(data.data()["band"]);
              address.add(data.data()["Address"]);
              decription.add(data.data()["decription"]);
              urlImage.add(data.data()["image"]);
              email.add(data.data()["email"]);
            }
            return ListView.builder(
              itemCount: title.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            title: title[index],
                            price: price[index],
                            address: address[index],
                            urlImg: urlImage[index],
                            email: email[index],
                            decription: decription[index],
                            brand: brand[index])));
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 105,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        top: 5,
                        child: Container(
                          height: 95,
                          child: AspectRatio(
                            aspectRatio: 10 / 10,
                            child: Container(
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: urlImage[index],
                                  placeholder: (context, url) {
                                    return Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromARGB(255, 238, 237, 237)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 110,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 105,
                          width: 190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(title[index], style: KmainPageTitleStye),
                              Text("Rs${price[index]}",
                                  style: KmainPagePriceStye),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded,
                                          size: 17, color: KgreyColor),
                                      Text(" now", style: KmainpageTimeStyle),
                                    ],
                                  ),
                                  Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 250, 90, 79),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))),
                                    child: Center(
                                        child: Text(
                                      "Promoted",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}

class DisplayItembuilder extends StatelessWidget {
  DisplayItembuilder({required this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("itemsForSell").snapshots(),
        builder: (context, snapshot) {
          List<Widget> SearchRgrids = [];
          List<Widget> SearcLgrids = [];

          List<Widget> rightGrids = [];
          List<Widget> leftGrids = [];
          int indexForGrid = 0;

          if (snapshot.hasData) {
            final datum = snapshot.data!.docs;

            for (var data in datum) {
              if (text != null &&
                  (data.data()["title"].toString().contains(text!) ||
                      data.data()["band"].toString().contains(text!))) {
                int indexForGridS = 0;

                if (indexForGrid.isEven) {
                  SearcLgrids.add(
                    GridWidget(
                        title: data.data()["title"],
                        price: data.data()["price"],
                        brand: data.data()["band"],
                        address: data.data()["Address"],
                        decription: data.data()["decription"],
                        urlImage: data.data()["image"],
                        email: data.data()["email"]),
                  );
                } else {
                  SearchRgrids.add(
                    GridWidget(
                        title: data.data()["title"],
                        price: data.data()["price"],
                        brand: data.data()["band"],
                        address: data.data()["Address"],
                        decription: data.data()["decription"],
                        urlImage: data.data()["image"],
                        email: data.data()["email"]),
                  );
                  indexForGrid++;
                }
              }

              if (indexForGrid.isEven) {
                leftGrids.add(
                  GridWidget(
                      title: data.data()["title"],
                      price: data.data()["price"],
                      brand: data.data()["band"],
                      address: data.data()["Address"],
                      decription: data.data()["decription"],
                      urlImage: data.data()["image"],
                      email: data.data()["email"]),
                );
                indexForGrid++;
              } else {
                rightGrids.add(
                  GridWidget(
                      title: data.data()["title"],
                      price: data.data()["price"],
                      brand: data.data()["band"],
                      address: data.data()["Address"],
                      decription: data.data()["decription"],
                      urlImage: data.data()["image"],
                      email: data.data()["email"]),
                );
                indexForGrid++;
              }
            }

            return Wrap(
              spacing: 5,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 5,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: text == null ? leftGrids : SearcLgrids,
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: text == null ? rightGrids : SearchRgrids,
                        )
                      ],
                    ),
                  ],
                )
              ],
            );
          } else {
            return CircularProgressIndicator(
              color: Colors.deepOrange,
            );
          }
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/constant.dart';

import '../main.dart';

class GridWidget extends StatelessWidget {
  final String title;
  final String price;
  final String brand;
  final String address;
  final String decription;
  final String urlImage;
  final String email;

  GridWidget(
      {required this.title,
      required this.price,
      required this.brand,
      required this.address,
      required this.decription,
      required this.urlImage,
      required this.email});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
                title: title,
                price: price,
                address: address,
                urlImg: urlImage,
                email: email,
                decription: decription,
                brand: brand)));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(
          vertical: 5,
        ),
        width: width / 2.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                      // margin: EdgeInsets.all(5),
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: urlImage,
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 25,
                        width: 25,
                        child: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 92, 91, 91).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            KHSpace(5),
            Text(
              title,
              style: KmainPageTitleStye.copyWith(fontWeight: FontWeight.w600),
            ),
            KHSpace(5),
            Text(
              "\Rs $price",
              style: KmainPagePriceStye,
            ),
            KHSpace(5),
            Row(
              children: [
                Text(
                  "Subhan",
                  style: KmainPageTitleStye,
                ),
                KWSpace(15),
                Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.deepOrange,
                ),
                KWSpace(3),
                Text(
                  "4.8",
                  style: KmainPagePriceStye,
                ),
              ],
            ),
            KHSpace(5),
            Text(
              brand,
              style: KmainpageTimeStyle,
            ),
            KHSpace(5),
            Row(
              children: [
                Icon(Icons.location_city, size: 17, color: KgreyColor),
                Text(
                  "3,00 km",
                  style: KmainpageTimeStyle,
                ),
                KWSpace(15),
                Row(
                  children: [
                    Icon(CupertinoIcons.checkmark_alt_circle,
                        size: 15, color: KgreyColor),
                    KWSpace(5),
                    Text(
                      "3,00 km",
                      style: KmainpageTimeStyle,
                    ),
                  ],
                )
              ],
            ),
            KHSpace(5),
          ],
        ),
        // height: height / 3.3,
      ),
    );
  }
}

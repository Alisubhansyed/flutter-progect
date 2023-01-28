// import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// import '';
import 'package:weaterapp/constant.dart';
import 'api.dart';
import 'auth/auth.dart';
import 'firebase_options.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // darkTheme: ThemeData(primaryColor: Colors.grey),
      theme: ThemeData.dark(),
      home: Auth(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool theme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  // color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 3,
                          color: Colors.white,
                        ),
                        kHSpacer(5),
                        Container(
                          width: 25,
                          height: 3,
                          color: Colors.white,
                        ),
                        kHSpacer(5),
                        Container(
                          width: 10,
                          height: 3,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search(),
                      ));
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        drawer: Container(
          width: 200,
          child: Drawer(
            child: Scaffold(
                body: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    trailing: Icon(Icons.search),
                    title: Text('Search'),
                  ),
                  Divider(),
                  ListTile(
                    trailing: Switch(
                      activeColor: Colors.grey,
                      inactiveTrackColor: Colors.white,
                      // inactiveThumbColor: Colors.black,
                      value: theme,
                      onChanged: (value) {
                        setState(() {});
                        theme = value;
                      },
                    ),
                    title: Text("Theme"),
                  ),
                  Divider(),
                  ListTile(
                    trailing: Icon(Icons.power_settings_new_outlined),
                    title: Text('Logout'),
                  ),
                ],
              ),
            )),
          ),
        ),
        body: ApiUi("lahore"));
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  String city = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: controller,
                  onChanged: (value) async {
                    setState(() {
                      city = value;
                    });
                  },
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: "Location",
                    label: Text(
                      "Search city",
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: search(city),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchUI(
                                            city: snapshot.data![index]
                                                .toString())));
                              },
                              title: Text(snapshot.data![index].toString()),
                            );
                          },
                        );
                      } else {
                        return Row(
                          children: [],
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchUI extends StatelessWidget {
  const SearchUI({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ApiUi(city));
  }
}

Widget ApiUi(String city) {
  return FutureBuilder(
    future: apiCall(city),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return snapshot.data != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  kHSpacer(5),
                  Text(
                    snapshot.data["location"]["name"].toString().toUpperCase(),
                    style: const TextStyle(
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  kHSpacer(10),
                  Text(
                    "${snapshot.data!['current']['temp_c']} °",
                    style: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.w200),
                  ),
                  kHSpacer(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${snapshot.data!['forecast']['forecastday'][0]['day']['maxtemp_c']} °",
                      ),
                      const Icon(Icons.arrow_drop_up_rounded),
                      Text("|  "),
                      Text(
                        "${snapshot.data!['forecast']['forecastday'][0]['day']['mintemp_c']} °",
                      ),
                      const Icon(Icons.arrow_drop_down_rounded),
                    ],
                  ),
                  kHSpacer(10),
                  Text(
                    snapshot.data['current']['condition']['text'].toString(),
                    style: const TextStyle(
                        letterSpacing: 10,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                  ),
                  kHSpacer(30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  // forecast.forecastday[0].hour
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: snapshot
                          .data['forecast']['forecastday'][0]['hour'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            kWSpacer(20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                kHSpacer(10),

                                Text(DateFormat('hh:mm a').format(
                                    DateTime.parse(snapshot.data['forecast']
                                            ['forecastday'][0]['hour'][index]
                                            ['time']
                                        .toString()))),
                                snapshot.data != null
                                    ? Image.network(
                                        'http:${snapshot.data['forecast']['forecastday'][0]['hour'][index]['condition']['icon']}',
                                        height: 50,
                                      )
                                    : Container(),
                                //  forecast.forecastday[0].hour[0].condition.icon
                                Text(
                                    "${snapshot.data['forecast']['forecastday'][0]['hour'][index]['temp_c']}°"),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.water_drop_sharp,
                                      color: Colors.grey.shade700,
                                      size: 15,
                                    ),
                                    // forecast.forecastday[0].hour[0].humidity
                                    Text(
                                      "${snapshot.data['forecast']['forecastday'][0]['hour'][index]['humidity']}%",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                kHSpacer(10),
                              ],
                            ),
                            kWSpacer(20),
                          ],
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      // forecast.forecastday
                      itemCount:
                          snapshot.data['forecast']['forecastday'].length,
                      itemBuilder: (context, position) {
                        print(snapshot.data['forecast']['forecastday'].length
                            .toString());
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // forecast.forecastday[0].date
                            //  Text(DateFormat('EEEE')
                            //         .format(DateTime.parse()))
                            Text(DateFormat('EEEE').format(DateTime.parse(
                                snapshot.data['forecast']['forecastday']
                                    [position]['date']))),
                            Row(
                              children: [
                                snapshot.data != null
                                    ? Image.network(
                                        'http:${snapshot.data['forecast']['forecastday'][position]['day']['condition']['icon']}',
                                        height: 50,
                                      )
                                    : Container(),
                                Icon(
                                  Icons.water_drop_sharp,
                                  color: Colors.grey.shade700,
                                  size: 15,
                                ),
                                // forecast.forecastday[0].hour[0].humidity
                                // forecast.forecastday[0].day.avghumidity
                                Text(
                                  "${snapshot.data['forecast']['forecastday'][position]['day']['avghumidity']}%",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                // forecast.forecastday[0].day.maxtemp_f
                                // forecast.forecastday[0].day.mintemp_c
                              ],
                            ),
                            Text(
                              '${snapshot.data['forecast']['forecastday'][position]['day']['maxtemp_c']}°/${snapshot.data['forecast']['forecastday'][position]['day']['mintemp_c']}'
                              '°',
                              style: TextStyle(letterSpacing: 1),
                            )

                            // forecast.forecastday[0].day.condition.icon
                          ],
                        );
                      },
                    ),
                  )
                ],
              )
            : const Text("loading");
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    },
  );
}

class Singup extends StatelessWidget {
  Singup({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 500,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 5),
                ),
                TextField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    label: Text(
                      "email",
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    // hintText: "Location",
                    label: Text(
                      "password",
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(
                  width: width,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("Register"),
                    ),

                    // shape: ClipRRect(
                    //   borderRadius:BorderRadius.circular(10) ,
                    // ),
                    onPressed: () {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Image.network(
                              "https://pbs.twimg.com/profile_images/1455185376876826625/s1AjSxph_400x400.jpg",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    kWSpacer(10),

                    // https://upload.wikimedia.org/wikipedia/commons/8/82/Facebook_icon.jpg
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text("login"),
                        ),

                        // shape: ClipRRect(
                        //   borderRadius:BorderRadius.circular(10) ,
                        // ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 500,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 5),
                ),
                TextField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    label: Text(
                      "email",
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    // hintText: "Location",
                    label: Text(
                      "password",
                      style: TextStyle(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(
                  width: width,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("Login"),
                    ),

                    // shape: ClipRRect(
                    //   borderRadius:BorderRadius.circular(10) ,
                    // ),
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(" Login with"),
                    Container(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Image.network(
                            "https://pbs.twimg.com/profile_images/1455185376876826625/s1AjSxph_400x400.jpg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

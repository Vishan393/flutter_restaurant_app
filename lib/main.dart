import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restaurant Demo', // Title of App
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue), // Theme of app
      home: const MyHomePage(),
    );
  }
}

// Home page
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width

    Future<List<Widget>> createList() async {
      List<Widget> items = [];
      String dataString =
          await DefaultAssetBundle.of(context).loadString("assets/data.json");
      List<dynamic> dataJSON = jsonDecode(dataString);

      dataJSON.forEach((object) {
        String finalString = "";
        List<dynamic> dataList = object["placeItems"];
        dataList.forEach((item) {
          finalString = finalString + item + " | ";
        });

        items.add(Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2.0,
                          blurRadius: 5.0),
                    ]),
                margin: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: Image.asset(object["placeImage"],
                          width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(object["placeName"]),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: Text(
                                finalString,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              "Min. Order: ${object["minOrder"]}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
      });

      return items;
    }

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
            child: SingleChildScrollView(
          // Separate sections into columns
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Create row with padding for menu. Can right click to refactor and insert more components
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Space between children elements like grid-template
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {}), // Menu icon
                    const Text(
                      "Little India",
                      style: TextStyle(fontSize: 50, fontFamily: "Samantha"),
                    ),
                    IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {}) // Person Icon
                  ],
                ),
              ),
              const BannerWidgetArea(), // Add the banner widget area to the home page
              Container(
                  child: FutureBuilder(
                      initialData: const <Widget>[Text("")],
                      future: createList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                // Causes height issue so you have to change the default
                                primary: false,
                                shrinkWrap: true,
                                children: snapshot.data!,
                              )); // Loads the data
                        } else {
                          return const CircularProgressIndicator(); // Loads a loading bar
                        }
                      })), // Add the list banners to the home page
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: Icon(MdiIcons.food, color: Colors.white)),
    );
  }
}

var bannerItems = ["Burger", "Cheese Chilly", "Noodles", "Pizza"];
var bannerImage = [
  "images/burger.jpg",
  "images/cheesechilly.jpg",
  "images/noodles.jpg",
  "images/pizza.jpg"
];

// Create new stateless widget buy typing "stl enter"
// Banner area
class BannerWidgetArea extends StatelessWidget {
  const BannerWidgetArea({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width

    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);

    List<Widget> banners = [];

    // Loop through the banner items adding them to the list, when they are all added we add them to the page view
    for (int i = 0; i < bannerItems.length; i++) {
      var bannerView = Padding(
        padding: const EdgeInsets.all(10.0), // Padding
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Box shadow located bellow the images
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, // Change the color of the black
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0)
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(20.0)), // Border radius
                  child: Image.asset(bannerImage[i], fit: BoxFit.cover)),

              // Tint located above the image
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54])),
              ),

              // Text on top of image
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(bannerItems[i],
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                    const Text("More than 40% Off",
                        style: TextStyle(fontSize: 12, color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }
    return Container(
        width: screenWidth,
        height: screenWidth * 9 / 16,
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: banners, // Add the banners from the list to the page view
        ));
  }
}

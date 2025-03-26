import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dashboard/book_model.dart';
import 'package:dashboard/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Dashboard extends StatefulWidget {
  final bool isDarkTheme;

  // Constructor with a default value for `isDarkTheme`
  const Dashboard({Key? key, this.isDarkTheme = false}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotchBottomBarController _controller =
  NotchBottomBarController(index: 0);
  bool isSearching = false;
  final ScrollController _scrollController = ScrollController();
  final int _itemCount = 10; // Number of items in the list
  final double _scrollSpeed = 1.0; // Scroll speed (pixels per frame)

  late Timer _timer;
  final themeController = Get.find<ThemeController>();


  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        // Adjust the scroll speed to a very small value
        double slowerSpeed = 1000.0; // Scroll 50 pixels at a time (you can fine-tune this value)

        // Scroll the ListView by a small amount every 10 seconds
        _scrollController.animateTo(
          _scrollController.offset + slowerSpeed,
          duration: Duration(seconds: 10), // Animation lasts for 3 seconds
          curve: Curves.linear,
        );

        // Check if we've reached the end of the list and reset the scroll position
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0); // Jump to the start if we reach the end
        }
      }
    });
  }

  // Demo data for each tab (category)
  List<List<Book>> demoData = [
    // Category 1
    [
      Book(id: 1, name: "Book 1", author: "Author 1", imageUrl: "assets/images/book1.jpg"),
      Book(id: 2, name: "Book 2", author: "Author 2", imageUrl: "assets/images/book2.jpg"),
      Book(id: 3, name: "Book 3", author: "Author 3", imageUrl: "assets/images/book3.jpg"),
      Book(id: 4, name: "Book 4", author: "Author 4", imageUrl: "assets/images/book4.jpg"),
      Book(id: 5, name: "Book 5", author: "Author 5", imageUrl: "assets/images/book5.jpg"),
      Book(id: 6, name: "Book 6", author: "Author 6", imageUrl: "assets/images/book6.jpg"),
      Book(id: 7, name: "Book 7", author: "Author 7", imageUrl: "assets/images/book7.jpg"),
      Book(id: 8, name: "Book 8", author: "Author 8", imageUrl: "assets/images/book8.jpg"),
      Book(id: 9, name: "Book 9", author: "Author 9", imageUrl: "assets/images/book9.jpg"),
      Book(id: 10, name: "Book 10", author: "Author 10", imageUrl: "assets/images/book10.jpg"),
    ],

    // Category 2
    [
      Book(id: 11, name: "Book 11", author: "Author 11", imageUrl: "assets/images/book11.jpg"),
      Book(id: 12, name: "Book 12", author: "Author 12", imageUrl: "assets/images/book12.jpg"),
      Book(id: 13, name: "Book 13", author: "Author 13", imageUrl: "assets/images/book13.jpg"),
      Book(id: 14, name: "Book 14", author: "Author 14", imageUrl: "assets/images/book14.jpg"),
      Book(id: 15, name: "Book 15", author: "Author 15", imageUrl: "assets/images/book15.jpg"),
      Book(id: 16, name: "Book 16", author: "Author 16", imageUrl: "assets/images/book16.jpg"),
      Book(id: 17, name: "Book 17", author: "Author 17", imageUrl: "assets/images/book17.jpg"),
      Book(id: 18, name: "Book 18", author: "Author 18", imageUrl: "assets/images/book18.jpg"),
      Book(id: 19, name: "Book 19", author: "Author 19", imageUrl: "assets/images/book19.jpg"),
      Book(id: 20, name: "Book 20", author: "Author 20", imageUrl: "assets/images/book20.jpg"),
    ],

    // Category 3
    [
      Book(id: 21, name: "Book 21", author: "Author 21", imageUrl: "assets/images/book21.jpg"),
      Book(id: 22, name: "Book 22", author: "Author 22", imageUrl: "assets/images/book22.jpg"),
      Book(id: 23, name: "Book 23", author: "Author 23", imageUrl: "assets/images/book23.jpg"),
      Book(id: 24, name: "Book 24", author: "Author 24", imageUrl: "assets/images/book24.jpg"),
      Book(id: 25, name: "Book 25", author: "Author 25", imageUrl: "assets/images/book25.jpg"),
      Book(id: 26, name: "Book 26", author: "Author 26", imageUrl: "assets/images/book26.jpg"),
      Book(id: 27, name: "Book 27", author: "Author 27", imageUrl: "assets/images/book27.jpg"),
      Book(id: 28, name: "Book 28", author: "Author 28", imageUrl: "assets/images/book28.jpg"),
      Book(id: 29, name: "Book 29", author: "Author 29", imageUrl: "assets/images/book29.jpg"),
      Book(id: 30, name: "Book 30", author: "Author 30", imageUrl: "assets/images/book30.jpg"),
    ],

    // Category 4
    [
      Book(id: 31, name: "Book 31", author: "Author 31", imageUrl: "assets/images/book31.jpg"),
      Book(id: 32, name: "Book 32", author: "Author 32", imageUrl: "assets/images/book32.jpg"),
      Book(id: 33, name: "Book 33", author: "Author 33", imageUrl: "assets/images/book33.jpg"),
      Book(id: 34, name: "Book 34", author: "Author 34", imageUrl: "assets/images/book34.jpg"),
      Book(id: 35, name: "Book 35", author: "Author 35", imageUrl: "assets/images/book35.jpg"),
      Book(id: 36, name: "Book 36", author: "Author 36", imageUrl: "assets/images/book36.jpg"),
      Book(id: 37, name: "Book 37", author: "Author 37", imageUrl: "assets/images/book37.jpg"),
      Book(id: 38, name: "Book 38", author: "Author 38", imageUrl: "assets/images/book38.jpg"),
      Book(id: 39, name: "Book 39", author: "Author 39", imageUrl: "assets/images/book39.jpg"),
      Book(id: 40, name: "Book 40", author: "Author 40", imageUrl: "assets/images/book40.jpg"),
    ],

    // Category 5
    [
      Book(id: 41, name: "Book 41", author: "Author 41", imageUrl: "assets/images/book41.jpg"),
      Book(id: 42, name: "Book 42", author: "Author 42", imageUrl: "assets/images/book42.jpg"),
      Book(id: 43, name: "Book 43", author: "Author 43", imageUrl: "assets/images/book43.jpg"),
      Book(id: 44, name: "Book 44", author: "Author 44", imageUrl: "assets/images/book44.jpg"),
      Book(id: 45, name: "Book 45", author: "Author 45", imageUrl: "assets/images/book45.jpg"),
      Book(id: 46, name: "Book 46", author: "Author 46", imageUrl: "assets/images/book46.jpg"),
      Book(id: 47, name: "Book 47", author: "Author 47", imageUrl: "assets/images/book47.jpg"),
      Book(id: 48, name: "Book 48", author: "Author 48", imageUrl: "assets/images/book48.jpg"),
      Book(id: 49, name: "Book 49", author: "Author 49", imageUrl: "assets/images/book49.jpg"),
      Book(id: 50, name: "Book 50", author: "Author 50", imageUrl: "assets/images/book50.jpg"),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      backgroundColor: themeController.isDarkTheme.value ? Colors.black : Colors.white, // Background color based on theme

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: isSearching
                  ? Container(
                height: 30,
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 12),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onSubmitted: (query) {},
                ),
              )
                  : Container(),
              background: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://www.skoolbeep.com/blog/wp-content/uploads/2020/12/HOW-DO-YOU-DESIGN-A-LIBRARY-MANAGEMENT-SYSTEM-min.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            floating: false,
            pinned: true,
            snap: false,
            elevation: 10.0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(isSearching ? Icons.close : CupertinoIcons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
              ),
              if (!isSearching)
                PopupMenuButton<dynamic>(
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white), 
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'settings',
                      child: Text(
                        'Settings',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'info',
                      child: Text(
                        'More Information',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'theme',
                      child: Obx(() => LiteRollingSwitch(
                        value: themeController.isDarkTheme.value, // Bind the observable value

                        colorOn: const Color(0xFF00BAAB),
                        colorOff: const Color(0xFF292929),
                        // textOnColor: Colors.white,
                        // textOffColor: Colors.white,
                        iconOn: Icons.nightlight,
                        iconOff: Icons.sunny,
                        textSize: 16.0,
                        onChanged: (bool state) {
                          // Toggle theme based on state change
                          if (state != themeController.isDarkTheme.value) {
                            themeController.toggleTheme();
                          }
                        }, onTap: (){}, onDoubleTap: (){}, onSwipe: (){},
                      )),
                    ),


                  ],
                  onSelected: (value) {
                    // Remove the theme toggle from here to avoid redundant toggling
                    if (value == 'settings') {
                      // Navigate to settings
                    } else if (value == 'info') {
                      // Show more information
                    }
                  },
                )

            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100, // Adjust the height as per your design
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Item ${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // TabBar and TabBarView
          SliverToBoxAdapter(
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: List.generate(5, (index) {
                      return Tab(
                        text: 'Category ${index + 1}', // Tab text for each tab
                      );
                    }),
                    indicatorColor: Colors.blue, // Color of the active tab indicator
                  ),
                  SizedBox(
                    height: 400, // Fixed height for the TabBarView
                    child: TabBarView(
                      controller: _tabController,
                      children: List.generate(5, (index) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: demoData[index].length,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemBuilder: (context, itemIndex) {
                              final book = demoData[index][itemIndex];
                              return Dismissible(
                                  onDismissed: (direction) {
                                    setState(() {
                                      demoData[index].removeAt(index);
                                    });
                                  },
                                  confirmDismiss: (DismissDirection direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      return await showRejectionDialog(context);
                                    } else {
                                      return showConfirmationDialog(context);
                                    }
                                  },
                                  background: Container(
                                    height: 50,
                                    color: Colors.red,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Delete',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    height: 50,
                                    color: Colors.blue,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Save',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  key: ValueKey<String>(book.id.toString()),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white),
                                    margin: const EdgeInsets.only(top: 10),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        book.name,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ));
                            });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: AnimatedNotchBottomBar(
      //   notchBottomBarController: _controller,
      //   color: Colors.white,
      //   showLabel: true,
      //   textOverflow: TextOverflow.visible,
      //   maxLine: 1,
      //   shadowElevation: 5,
      //   kBottomRadius: 28.0,
      //   notchColor: Colors.black87,
      //   removeMargins: false,
      //   bottomBarWidth: MediaQuery.of(context).size.width,
      //   showShadow: false,
      //   durationInMilliSeconds: 300,
      //   itemLabelStyle: const TextStyle(fontSize: 10),
      //   elevation: 1,
      //   bottomBarItems: const [
      //     BottomBarItem(
      //       inActiveItem: Icon(
      //         Icons.home_filled,
      //         color: Colors.blueGrey,
      //       ),
      //       activeItem: Icon(
      //         Icons.home_filled,
      //         color: Colors.blueAccent,
      //       ),
      //       itemLabel: 'Home',
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(Icons.star, color: Colors.blueGrey),
      //       activeItem: Icon(
      //         Icons.star,
      //         color: Colors.blueAccent,
      //       ),
      //       itemLabel: 'Collection',
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(
      //         Icons.settings,
      //         color: Colors.blueGrey,
      //       ),
      //       activeItem: Icon(
      //         Icons.settings,
      //         color: Colors.pink,
      //       ),
      //       itemLabel: 'Page 3',
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(
      //         Icons.person,
      //         color: Colors.blueGrey,
      //       ),
      //       activeItem: Icon(
      //         Icons.person,
      //         color: Colors.yellow,
      //       ),
      //       itemLabel: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     print('current selected index $index');
      //   },
      //   kIconSize: 24.0,
      // ),
    );
  }
  Future<bool?> showConfirmationDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: const Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Show the success message as a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF00BAAB)),
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFF00BAAB)),
              SizedBox(width: 10),
              Text(
                'Success! ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
              Text(
                'Item successfully saved.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return confirmed; // Return the dialog result
  }
  Future<bool?> showRejectionDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: const Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Show the success message as a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF00BAAB)),
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFF00BAAB)),
              SizedBox(width: 10),
              Text(
                'Success! ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
              Text(
                'Item successfully Deleted.',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return confirmed; // Return the dialog result
  }

}
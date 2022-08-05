import 'package:flutter/material.dart';
import 'package:youtube_sync_music/screens/sync_music.dart';
import 'package:youtube_sync_music/screens/upload_music_page.dart';

import '../theme/colors.dart';
import 'home_page.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: [
        const HomePage(),
        const SyncMusic(),
        const Center(
          child: Text(
            "Search",
            style: TextStyle(
                fontSize: 20, color: white, fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text(
            "Setings",
            style: TextStyle(
                fontSize: 20, color: white, fontWeight: FontWeight.bold),
          ),
        ),
        Upload()
      ],
    );
  }

  Widget getFooter() {
    List items = [
      Icons.home,
      Icons.book,
      Icons.search,
      Icons.settings,
      Icons.upload
    ];
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: black),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              return IconButton(
                  icon: Icon(
                    items[index],
                    color: activeTab == index ? primary : white,
                  ),
                  onPressed: () {
                    setState(() {
                      activeTab = index;
                    });
                  });
            })),
      ),
    );
  }
}

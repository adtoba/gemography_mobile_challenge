import 'package:flutter/material.dart';
import 'package:gemography_mobile_challenge/pages/repos_page.dart';
import 'package:gemography_mobile_challenge/styles/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController;

  List<Widget> _pages = <Widget>[
    ReposPage(),
    ReposPage()
  ];

  int _activeIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
        keepPage: true,
        initialPage: 0
    );
    super.initState();
  }

  void onPageChanged(int index) {
    _pageController.animateToPage(
        index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text('Trending Repos'),
        backgroundColor: GColors.white,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: onPageChanged
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeIndex,
        onTap: onPageChanged,
        selectedItemColor: GColors.blue,
        unselectedItemColor: GColors.grey,
        backgroundColor: GColors.white,
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Trending",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings"
          )
        ],
      ),
    );
  }
}

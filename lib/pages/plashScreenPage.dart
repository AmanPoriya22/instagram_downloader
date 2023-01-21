import 'package:flutter/material.dart';
import 'package:introduction_slider/introduction_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class PlashScreenPage extends StatefulWidget {
  const PlashScreenPage({Key? key}) : super(key: key);

  @override
  State<PlashScreenPage> createState() => _PlashScreenPageState();
}

class _PlashScreenPageState extends State<PlashScreenPage> {

  bool showInformationScreen = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpData();
  }

  Future getSpData() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){
      if(prefs.getBool('showInformationScreen') != null) {
        showInformationScreen = prefs.getBool('showInformationScreen')!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showInformationScreen
        ? IntroductionSlider(
            items: [
              IntroductionSliderItem(
                title: const Expanded(
                  child: Center(
                    child: Text(
                      "Title 1",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                logo: Expanded(
                  child: Center(
                    child: Image.asset('assets/images/instagram_white.png'),
                  ),
                ),
                subtitle: const Expanded(
                  child: Center(
                    child: Text(
                      'SubTitle',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                backgroundColor: Colors.red,
              ),
              const IntroductionSliderItem(
                title: Expanded(
                  child: Center(
                    child: Text(
                      "Title 1",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                logo: Expanded(
                  child: Center(
                    child: FlutterLogo(),
                  ),
                ),
                subtitle: Expanded(
                  child: Center(
                    child: Text(
                      'SubTitle',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                backgroundColor: Colors.green,
              ),
              const IntroductionSliderItem(
                title: Expanded(
                  child: Center(
                    child: Text(
                      "Title 1",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                logo: Expanded(
                  child: Center(
                    child: FlutterLogo(),
                  ),
                ),
                subtitle: Expanded(
                  child: Center(
                    child: Text(
                      'SubTitle',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                backgroundColor: Colors.blueAccent,
              ),
            ],
            showStatusBar: true,
            done: Done(
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
              home: HomePage(pageIndex: 0),
            ),
            dotIndicator: const DotIndicator(
                selectedColor: Colors.black, unselectedColor: Colors.white),
          )
        : HomePage(pageIndex: 0);
  }
}

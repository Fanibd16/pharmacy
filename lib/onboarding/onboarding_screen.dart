import 'package:flutter/material.dart';
import 'package:pharmacy/onboarding/onboarding_content.dart';
import 'package:pharmacy/onboarding/size_config.dart';
import 'package:pharmacy/pages/wel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  late SharedPreferences started;
  bool isStarted = false;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
    initStarted();
  }

  void initStarted() async {
    started = await SharedPreferences.getInstance();
    bool? hasStarted = started.getBool('iStarted');
    setState(() {
      isStarted = hasStarted ?? false;
    });
  }

  int _currentPage = 0;

  List<LinearGradient> colors = [
    const LinearGradient(
      colors: [Color(0xff674fff), Color(0xff9775dc)],
    ),
    const LinearGradient(
      colors: [Color(0xff674fff), Color(0xff9775dc)],
    ),
    const LinearGradient(
      colors: [Color(0xff674fff), Color(0xff9775dc)],
    ),
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return isStarted
        ? const WelcomeScreen()
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: colors[_currentPage]),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        onPageChanged: (value) =>
                            setState(() => _currentPage = value),
                        itemCount: contents.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  contents[i].image,
                                  height: SizeConfig.blockV! * 30,
                                ),
                                SizedBox(height: (height >= 840) ? 60 : 30),
                                Text(
                                  contents[i].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.w600,
                                    fontSize: (width <= 550) ? 30 : 35,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  contents[i].desc,
                                  style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.w300,
                                    fontSize: (width <= 550) ? 17 : 25,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              contents.length,
                              (int index) => _buildDots(index: index),
                            ),
                          ),
                          _currentPage + 1 == contents.length
                              ? Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isStarted = true;
                                        started.setBool('iStarted', true);
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WelcomeScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xffffffff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                      ),
                                      padding: (width <= 550)
                                          ? const EdgeInsets.symmetric(
                                              horizontal: 100, vertical: 20)
                                          : EdgeInsets.symmetric(
                                              horizontal: width * 0.2,
                                              vertical: 25),
                                      textStyle: TextStyle(
                                          fontSize: (width <= 550) ? 13 : 17),
                                    ),
                                    child: const Text(
                                      "START",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _controller.jumpToPage(2);
                                        },
                                        style: TextButton.styleFrom(
                                          elevation: 0,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (width <= 550) ? 13 : 17,
                                          ),
                                        ),
                                        child: const Text(
                                          "SKIP",
                                          style: TextStyle(
                                              color: Color(0xffffffff)),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _controller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeIn,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffffffff),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          elevation: 0,
                                          padding: (width <= 550)
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 20)
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 25),
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  (width <= 550) ? 13 : 17),
                                        ),
                                        child: const Text(
                                          "NEXT",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

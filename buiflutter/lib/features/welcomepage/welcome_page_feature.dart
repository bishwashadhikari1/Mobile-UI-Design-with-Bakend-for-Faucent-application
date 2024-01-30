import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/features/auth/presentation/view/auth_view.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __WelcomePageState();
}

class __WelcomePageState extends ConsumerState<WelcomePage> {
  int _currentPage = 0;
  final List<String> _imagesList = [
    "assets/logo1.png",
  ];
  final List<List<String>> _textList = [
    ["Innovate your payroll", "system"],
  ];
  final List<List<String>> _subTextList = [
    [
      "Never wait till the end of the month ",
      "to get paid. Get paid as you work."
    ],
  ];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _imagesList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            _imagesList[index],
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.5,
                            fit: BoxFit.contain,
                          ),
                          ..._textList[index].map(
                            (text) => Padding(
                              padding:
                                  EdgeInsets.only(top: 0.02 * screenHeight),
                              child: Text(
                                text,
                                style: const TextStyle(
                                    fontFamily: 'sf-bold',
                                    fontSize: 24,
                                    color: AppColorConstant.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          ..._subTextList[index].map(
                            (subText) => Padding(
                              padding:
                                  EdgeInsets.only(top: 0.01 * screenHeight),
                              child: Text(
                                subText,
                                style: const TextStyle(
                                  fontFamily: 'sf-regular',
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/welcomelogo.png',
                          width: 70.0,
                          height: 30.0,
                        ),
                        SizedBox(width: 8.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginRegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            "SKIP",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children:
            //             List<Widget>.generate(_imagesList.length, _buildDot),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.only(
            //           bottom: 0.02 * screenHeight,
            //           right: 0.04 * screenWidth,
            //         ),
            //         child: Align(
            //           alignment: Alignment.bottomRight,
            //           child: FloatingActionButton(
            //             backgroundColor: AppColorConstant.white,
            //             elevation: 0,
            //             onPressed: () {
            //               if (_currentPage == _imagesList.length - 1) {
            //                 Navigator.pushReplacement(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => const LandingPage(),
            //                   ),
            //                 );
            //               } else {
            //                 _pageController.nextPage(
            //                   duration: const Duration(milliseconds: 400),
            //                   curve: Curves.easeIn,
            //                 );
            //               }
            //             },
            //             child: Icon(
            //               Icons.arrow_forward_ios,
            //               size: 0.05 * screenHeight,
            //               color: AppColorConstant.primarycolor,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
            // if (_currentPage == _imagesList.length - 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _imagesList.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginRegisterView(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColorConstant
                          .appBarColor, // Text Color (Foreground color)
                      padding: const EdgeInsets.symmetric(
                          vertical: 12), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Button corner radius
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20), // Button text style
                    ),
                  ),
                  const SizedBox(height: 20), // Space between button and dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List<Widget>.generate(_imagesList.length, _buildDot),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width: _currentPage == index ? 15.0 : 15.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColorConstant.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

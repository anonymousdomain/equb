import 'package:equb/helper/images.dart';
import 'package:equb/helper/switch_handler.dart';
import 'package:equb/screens/onboarding_screen/build_page.dart';
import 'package:equb/widget/custom_button.dart';
import 'package:equb/widget/login_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  List<Widget> screens = [
    BuildPage(
        images: Images.save, text: 'Equb is here to make your life better '),
    BuildPage(
        images: Images.progress, text: 'make your life better with equeb'),
    BuildPage(images: Images.pay, text: 'get Your equb on your hand')
  ];
  bool isLastPage = false;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  navigate() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: ((context) => SwitchHndler())));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: screens.length,
          onPageChanged: ((value) {
            setState(() {
              isLastPage = value == 2;
            });
          }),
          itemBuilder: ((context, pageIndex) {
            return Stack(
              children: [
                screens[pageIndex],
                Positioned(
                    right: 25,
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () => _pageController.animateToPage(index,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn),
                            child: Container(
                              width: 8,
                              height: pageIndex == index ? 25 : 8,
                              decoration: BoxDecoration(
                                  color: pageIndex == index
                                      ? Colors.indigo
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        );
                      }),
                    ))
              ],
            );
          }),
        ),
      ),
      bottomSheet: isLastPage
          ? CustomButton(title: 'Get Started', onTap: navigate)
          : Container(
             color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _pageController.nextPage(
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeIn),
                    child: Text('Next'),
                  ),
                  TextButton(
                    onPressed: () => _pageController.jumpToPage(2),
                    child: Text('Skip'),
                  )
                ],
              ),
            ),
    );
  }
}

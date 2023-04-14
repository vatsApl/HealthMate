import 'package:carousel_slider/carousel_slider.dart';
import 'package:clg_project/UI/signin_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import '../widgets/bg_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> items = [
    BGImages(
        imagePath:
            // 'https://images.unsplash.com/photo-1586073305502-5c5cc4a594bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTN8fG1vYmlsZSUyMHdhbGxwYXBlcnN8ZW58MHx8MHx8&auto=format&fit=crop&w=1400&q=60',
        'https://images.unsplash.com/photo-1584467735871-8e85353a8413?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8aGVhbHRoY2FyZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        text1: 'This is text 1'),
    BGImages(
        imagePath:
            // 'https://images.unsplash.com/photo-1613755340012-170e864dfe02?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzR8fG1vYmlsZSUyMHdhbGxwYXBlcnN8ZW58MHx8MHx8&auto=format&fit=crop&w=1400&q=60',
            'https://images.unsplash.com/photo-1611764461465-09162da6465a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDN8fGhlYWx0aGNhcmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        text1: 'This is text 2'),
    BGImages(
      imagePath:
          // 'https://images.unsplash.com/photo-1548063032-ce4d0e5aab66?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjJ8fG1vYmlsZSUyMHdhbGxwYXBlcnN8ZW58MHx8MHx8&auto=format&fit=crop&w=1400&q=60',
          'https://images.unsplash.com/photo-1666214276372-24e331683e78?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxzZWFyY2h8NTV8fGhvc3BpdGFsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
      text1: 'This is text 3',
    ),
  ];

  var activeIndex = 0;
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: items,
          options: CarouselOptions(
              height: double.infinity,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 150.0),
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: items.length,
            effect: const ExpandingDotsEffect(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 180.0, bottom: 50.0),
              child: activeIndex == 2
                  ? Visibility(
                      visible: isVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedBtn(
                          btnTitle: 'Get Started',
                          bgColor: kDefaultPurpleColor,
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SignInPage(), //undo this when server is on <=
                                  // builder: (context) => ClientMainPage(),
                                ),
                                (route) => false);
                          },
                        ),
                      ),
                    )
                  : Visibility(
                      visible: !isVisible,
                      child: Container(),
                    ),
            ),
          ],
        )
      ],
    ));
  }
}

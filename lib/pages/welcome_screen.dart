import 'package:carousel_slider/carousel_slider.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';
import '../ui/signin/view/signin_page.dart';
import '../widgets/bg_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var activeIndex = 0;
  bool isVisible = true;
  //List of splash screen images urls
  List<Widget> items = [
    BGImages(
      imagePath:
          'https://images.unsplash.com/photo-1584467735871-8e85353a8413?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8aGVhbHRoY2FyZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    ),
    BGImages(
      imagePath:
          'https://images.unsplash.com/photo-1611764461465-09162da6465a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDN8fGhlYWx0aGNhcmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
    ),
    BGImages(
      imagePath:
          'https://images.unsplash.com/photo-1666214276372-24e331683e78?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxzZWFyY2h8NTV8fGhvc3BpdGFsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    ),
  ];

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
            padding: const EdgeInsets.only(bottom: Dimens.pixel_150),
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
                padding: const EdgeInsets.only(
                  top: Dimens.pixel_180,
                  bottom: Dimens.pixel_50,
                ),
                child: activeIndex == 2
                    ? Visibility(
                        visible: isVisible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.pixel_20,
                          ),
                          child: ElevatedBtn(
                            btnTitle: Strings.text_get_started,
                            bgColor: AppColors.kDefaultPurpleColor,
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    // builder: (context) => SignInPage(),
                                    builder: (context) => SigninPage(),
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
      ),
    );
  }
}

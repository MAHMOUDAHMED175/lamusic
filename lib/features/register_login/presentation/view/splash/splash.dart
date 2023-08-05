import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/core/utils/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../confg/cacheHelper.dart';
import '../../../../../confg/theme.dart';
import '../auth/auth.dart';

class BoardingModel {
  String? lottie;
  String? title;
  String? body;

  BoardingModel({
    required this.lottie,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var borderController = PageController();
  bool isLast = false;
  List<BoardingModel> boarding = [
    BoardingModel(
      lottie: 'assets/lottie/splash3.json',
      title: 'ENJOY THE BEST',
      body: 'MUSIC WITH US',
    ),
    BoardingModel(
      lottie: 'assets/lottie/splash4.json',
      body: "YOUR MUSIC",
      title: 'SING A SONG',
    ),
    BoardingModel(
      lottie: 'assets/lottie/splash2.json',
      body: 'YOUR MUSIC',
      title: 'DOWNLOADS',
    ),
  ];

  void submit() {
    CacheHelper.savedData(key: "onBoarding", value: true).then((value) {
      if (value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthPage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, actions: [
        TextButton(
          onPressed: () {
            submit();
          },
          child: Text('SKIP',
              style: Styles.textStyle16.copyWith(
                color: ColorsApp.orangeColor,
              )),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              //ال pageView دي الصفحه اللى قبل تسجل الدخول اللى بتعرفك على التطبيق
              child: PageView.builder(
                reverse: false,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                controller: borderController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.1,
            ),
            Row(
              children: [
                //دى علشان شكل التلت نقط اللى هتتحرك لما احرك الشاشات والنقط تتحرك معاها اسمها //indacator

                SmoothPageIndicator(
                  controller: borderController,
                  effect: ExpandingDotsEffect(
                    dotColor: lightTheme.dialogBackgroundColor,
                    activeDotColor: lightTheme.primaryColor,
                    dotHeight: 15,
                    expansionFactor: 4,
                    dotWidth: 15,
                    spacing: 5,
                  ),
                  count: boarding.length,
                ),

                const Spacer(),
                //علشان يرمى اللى بعديه فى اخر الصفحه يعنى بيبعد اللى قبليه عن اللى بعديه
                FloatingActionButton(
                  // backgroundColor: ColorsApp.orangeColor,
                  onPressed: () {
                    borderController.nextPage(
                        duration: const Duration(microseconds: 20),
                        curve: Curves.easeOutQuart);
                    if (isLast) {
                      submit();
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel boardingForModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Lottie.asset(boardingForModel.lottie!),
          ),
          const SizedBox(
            height: 20.1,
          ),
          Text(
            boardingForModel.title!,
            style: Styles.textStyle30,
          ),
          const SizedBox(
            height: 20.1,
          ),
          Text(
            boardingForModel.body!,
            style: Styles.textStyle20,
          ),
          const SizedBox(
            height: 15.1,
          ),
        ],
      );
}

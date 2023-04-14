import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CvResume extends StatelessWidget {
  const CvResume({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(Images.ic_left_arrow)),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    Images.ic_true,
                    height: 28.0,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 23.0,
            ),
            TitleText(title: 'CV & Resume'),
            const SizedBox(
              height: 48.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 334,
                  height: 471,
                  child: Image.network(
                      'https://media.istockphoto.com/id/539984452/photo/undefined-text-french-handwritten-letter-handwriting.jpg?s=1024x1024&w=is&k=20&c=Awd4nSAD5wQqPiG5qKqcUcT_Pd8Z6u9QjmeOXCnkxb0='),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(color: kDefaultPurpleColor)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Add New Resume',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: kDefaultPurpleColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

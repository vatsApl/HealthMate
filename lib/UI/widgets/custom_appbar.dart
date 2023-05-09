import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../allAPIs/allAPIs.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/images.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.svgPictureLeading,
      this.onTapLeading,
      this.name,
      this.role,
      this.svgPictureTrailing,
      this.netImg})
      : super(key: key);

  String? name;
  String? role;
  String? svgPictureTrailing;
  String? netImg;
  String? svgPictureLeading;
  Function? onTapLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: AppBar(
        leading: svgPictureLeading != null
            ? GestureDetector(
                onTap: () {
                  onTapLeading!();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    svgPictureLeading ?? '',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: '${DataURL.baseUrl}/$netImg',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircleAvatar(
                  child: SvgPicture.asset(
                    Images.ic_person,
                    color: Colors.white,
                    height: 35.0,
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: SvgPicture.asset(
                    Images.ic_person,
                    color: Colors.white,
                    height: 35.0,
                  ),
                ),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: role == null ? 16.0 : 0.0,
              ),
              child: Text(
                name ?? '',
                style: const TextStyle(
                  color: AppColors.kDefaultPurpleColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                role ?? '',
                style: const TextStyle(
                  color: Color(0xff030837),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        actions: [
          SvgPicture.asset(svgPictureTrailing ?? ''),
        ],
        elevation: 0.0,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

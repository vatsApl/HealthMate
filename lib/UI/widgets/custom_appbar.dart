import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../allAPIs/allAPIs.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../../resourse/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.pixel_16,
      ),
      child: AppBar(
        backgroundColor: Colors.white,
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
            : Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '${DataURL.baseUrl}/${netImg}',
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
                  Positioned(
                    right: Dimens.pixel_0,
                    bottom: Dimens.pixel_3,
                    child: CircleAvatar(
                      radius: Dimens.pixel_8,
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                        radius: Dimens.pixel_6,
                        backgroundColor: AppColors.kGreenColor,
                      ),
                    ),
                  )
                ],
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
                style: TextStyle(
                  color: AppColors.kDefaultBlackColor,
                  fontSize: Dimens.pixel_14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
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

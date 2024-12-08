import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/imageassets.dart';
import '../../../../../core/functions/launch_url.dart';
import 'custombuttonauth.dart';

class LinkIconSocial extends StatefulWidget {
  const LinkIconSocial({super.key});

  @override
  State<StatefulWidget> createState() => _LinkIconSocial();


}

class _LinkIconSocial extends State<LinkIconSocial> {
  String? facebook;
  String? youtube;
  String? elearningOI;
  String? oiLink;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // قراءة البيانات المخزنة من SharedPreferences
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      facebook = prefs.getString("facebook");
      youtube = prefs.getString("youtube");
      elearningOI = prefs.getString("elearningOI");
      oiLink = prefs.getString("oiLink");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // التأكد من وجود الرابط قبل استخدامه
          if (facebook != null)
            CustomButtonAuthIcons(
              onPressed: () {
                webSite(facebook!);  // فتح رابط الفيسبوك
              },
              iconData: FontAwesome.facebook,
            ),
          if (oiLink != null)
            CustomButtonAuthIcons(
              onPressed: () {
                webSite(oiLink!);  // فتح رابط الموقع الخاص بالمؤسسة
              },
              iconData: FontAwesome.globe,
            ),
          if (youtube != null)
            CustomButtonAuthIcons(
              onPressed: () {
                webSite(youtube!);  // فتح رابط اليوتيوب
              },
              iconData: FontAwesome.youtube_play,
            ),
          if (elearningOI != null)
            CustomButtonAuthImages(
              onPressed: () {
                webSite(elearningOI!);  // فتح رابط موقع التعليم
              },
              image: AppImageAssets.moodleLogo,
            ),
        ],
      ),
    );
  }
}

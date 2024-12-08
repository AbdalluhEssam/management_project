import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:noqta/common/widgets/button/window_buttons.dart';
import 'package:noqta/core/configs/assets/image_assets.dart';
import 'package:noqta/core/constants/colors.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.primaryColor, // لون شريط العنوان
        border: Border.all(color: AppColor.primaryColor, width: 3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              alignment: Alignment.center,
              ImagesAssets.logoApp, // مسار الشعار
              height: 40,
              color: AppColor.white,
            ),
          ),
          Expanded(
            child: MoveWindow(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "NOQTA",
                  style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const WindowButtons(), // زراغ التحكم في النافذة
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constant/color.dart';

class CustomButtonAuth extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? color;
  final Color? textColor;

  const CustomButtonAuth({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color?.withOpacity(0.8) ?? AppColor.primaryColor.withOpacity(0.8),
            AppColor.primaryColor
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        height: 40,
        minWidth: Get.width * 0.9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        // color: color ?? AppColor.primaryColor,
        textColor: textColor ?? Colors.white,
        onPressed: onPressed,
        elevation: 5,
        splashColor: Colors.white.withOpacity(0.2),
        highlightElevation: 8,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomButtonAuthIcons extends StatelessWidget {
  final void Function() onPressed;
  final IconData iconData;

  const CustomButtonAuthIcons(
      {super.key, required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton(
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(AppColor.primaryColor),
                side: MaterialStatePropertyAll(
                    BorderSide(color: AppColor.primaryColor)),
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                shape: MaterialStatePropertyAll(CircleBorder())),
            onPressed: onPressed,
            child: Icon(
              iconData,
              color: AppColor.backgroundColor,
              size: 30,
            )),
      ),
    );
  }
}

class CustomButtonAuthImages extends StatelessWidget {
  final void Function() onPressed;
  final String image;

  const CustomButtonAuthImages(
      {super.key, required this.onPressed, required this.image});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppColor.primaryColor),
              side: MaterialStatePropertyAll(
                  BorderSide(color: AppColor.primaryColor)),
              padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              shape: MaterialStatePropertyAll(CircleBorder())),
          onPressed: onPressed,
          child: Image.asset(
            image,
            width: 30,
            height: 30,
          )),
    ));
  }
}

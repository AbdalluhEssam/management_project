import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:noqta/Features/calculator/presentation/pages/calculator_page.dart';
import 'package:noqta/core/constants/colors.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: AppColor.white,
      mouseOver: AppColor.white,
      mouseDown: AppColor.white,
      iconMouseOver: AppColor.primaryColor,
      iconMouseDown: AppColor.primaryColor,
    );

    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.calculate, color: AppColor.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const Dialog(
                  child: SizedBox(
                    width: 300,
                    height: 500,
                    child: CalculatorPage(),
                  ),
                );
              },
            );
          },
        ),
        MinimizeWindowButton(colors: buttonColors, animate: true),
        MaximizeWindowButton(colors: buttonColors, animate: true),
        CloseWindowButton(colors: buttonColors, animate: true),
      ],
    );
  }
}

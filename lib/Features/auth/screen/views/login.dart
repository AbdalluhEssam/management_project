import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oi_tawasol/Features/auth/screen/widget/auth/link_icon_socail.dart';
import 'package:oi_tawasol/core/constant/icon_broken.dart';
import 'package:oi_tawasol/core/constant/imageassets.dart';
import '../../controller/login_controller.dart';
import '../../../../core/class/handlingdataview.dart';
import '../../../../core/constant/color.dart';
import '../../../../core/functions/alertextiapp.dart';
import '../../../../core/functions/validinput.dart';
import '../widget/auth/custombuttonauth.dart';
import '../widget/auth/customtextformauth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      // حدد التصميم الأساسي الذي تم بناء الواجهة عليه
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 0,
          ),
          body: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              return WillPopScope(
                onWillPop: alertExitApp,
                child: GetBuilder<LoginControllerImp>(
                  builder: (controller) => HandlingDataRequest(
                    statusRequest: controller.statusRequest,
                    widget: Form(
                      key: controller.formState,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          top: 0.h,
                          bottom: 40.h,
                          right: 30.w,
                          left: 30.w,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColor.secondColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(200),
                            bottomLeft: Radius.circular(200),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AppImageAssets.logoApp,
                                  width: 150.w, height: 150.h),
                              Text(
                                'مرحبا بكم فى "OI Tawasol"',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: AppColor.black,
                                      fontSize: 22.spMin,
                                    ),
                              ),
                              SizedBox(height: 30.h),
                              if (controller.selectedValue == "ولى الامر" ||
                                  controller.selectedValue == "خريج")
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColor.primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0.r),
                                    ),
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.w, vertical: 5.h),
                                    foregroundColor: AppColor.primaryColor,
                                  ),
                                  onPressed: () {
                                    controller.checkAndShowDialog();
                                  },
                                  icon: const Icon(Icons.search),
                                  label:
                                      const Text("ابحث عن كودك بالرقم القومى"),
                                ),
                              SizedBox(height: 12.h),
                              CustomFormAuth(
                                isNamber: false,
                                valid: (val) {
                                  return validInput(val!, 1, 100, "code");
                                },
                                onChanged: (val) {
                                  controller.formState.currentState!.validate();
                                  return null;
                                },
                                mycontroller: controller.email,
                                label: "كود الطالب",
                                hinttext: "ادخل الكود",
                                iconData: IconBroken.Message,
                              ),
                              SizedBox(height: 12.h),
                              GetBuilder<LoginControllerImp>(
                                builder: (controller) => CustomFormAuth(
                                  isNamber: false,
                                  onTap: () {
                                    controller.showPassword();
                                  },
                                  obscureText: controller.isShowPassword,
                                  valid: (val) {
                                    return validInput(val!, 1, 40, "password");
                                  },
                                  onChanged: (val) {
                                    controller.formState.currentState!
                                        .validate();
                                    return null;
                                  },
                                  mycontroller: controller.password,
                                  label: "password".tr,
                                  hinttext: "Enter your password".tr,
                                  iconData: IconBroken.Lock,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.h),
                                decoration: const BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30))),
                                child: DropdownButton<String>(
                                  value: controller.selectedValue,
                                  hint: const Text(
                                    'اختر نوع',
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  isExpanded: true,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  underline: Container(
                                    width: Get.width,
                                    height: 1.h,
                                    decoration: const BoxDecoration(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  dropdownColor: AppColor.white,
                                  items: controller.options.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.spMin),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    controller.selectedValue = newValue;
                                    log(controller.selectedValue.toString());
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(height: 16.h),
                              CustomButtonAuth(
                                text: "signin".tr,
                                onPressed: () async {
                                  if (controller.selectedValue == "مسئول") {
                                    await controller.loginInAdmin();
                                  } else if (controller.selectedValue ==
                                      "طالب") {
                                    await controller.login();
                                  } else {
                                    await controller.login();
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Container(
                                      height: 1.h,
                                      width: Get.width * 0.2,
                                      color: AppColor.primaryColor,
                                    )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text("تصفح مواقعنا",
                                          style: TextStyle(
                                              fontSize: 16.spMin,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo",
                                              color: AppColor.primaryColor)),
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 1.h,
                                        width: Get.width * 0.2,
                                        color: AppColor.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GetBuilder<LoginControllerImp>(
                                initState: (state) =>
                                    state.controller?.update(),
                                builder: (controller) => HandlingDataRequest(
                                    statusRequest: controller.statusRequestLink,
                                    widget: const LinkIconSocial()),
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

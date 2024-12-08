import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oi_tawasol/core/class/handlingdataview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/class/download_app.dart';
import '../../../core/class/statusrequest.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/icon_broken.dart';
import '../../../core/constant/routes.dart';
import '../../../core/functions/handlingdatacontroller.dart';
import '../../../core/functions/translatedordatabase.dart';
import '../../../core/functions/validinput.dart';
import '../../../core/services/services.dart';
import '../../../view/widget/auth/customtextformauth.dart';
import '../data/data_source/auth/login.dart';
import '../data/model/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

abstract class LoginController extends GetxController {
  login();
}

class LoginControllerImp extends LoginController {
  LoginData loginData = LoginData(Get.find());
  Map user = {};
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<FormState> formState2 = GlobalKey<FormState>(); // Key for the second form

  late TextEditingController email;
  late TextEditingController password;
  StatusRequest statusRequest = StatusRequest.none;
  StatusRequest statusRequestCode = StatusRequest.none;
  StatusRequest statusRequestLink = StatusRequest.none;

  bool isShowPassword = true;
  MyServices myServices = Get.find();
  late String token;
  late String cohortId;
  late String idNumber;
  late String nameCohorts;
  late String userID;
  late String codeSTD;
  late String nameSTD;
  late String emailSTD;
  late String studentPhone;
  late String imageUrl;

  showPassword() {
    isShowPassword = isShowPassword == true ? false : true;
    update();
  }

  String? selectedValue = "طالب";

  final List<String> options = [
    'طالب',
    'خريج',
    'ولى الامر',
    'مسئول',
  ];
  final nationalIdController = TextEditingController();
  String? nationalIdCode;
  String? nameCode;

  void checkAndShowDialog() {
    if (selectedValue == "ولى الامر" || selectedValue == "خريج") {
      Get.defaultDialog(
        title: "أدخل الرقم القومي للطالب",
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
        ),
        content: GetBuilder<LoginControllerImp>(
          // استخدام GetBuilder لتحديث الواجهة
          builder: (controller) {
            return HandlingDataRequest(
              statusRequest: controller.statusRequestCode,
              widget: Form(
                key: controller.formState2,
                child: Column(
                  children: [

                      CustomFormAuth(
                        isNamber: true,
                        valid: (val) {
                          return validInput(val!, 14, 14, "code");
                        },
                        onChanged: (val) {
                          formState.currentState!.validate();
                          return null;
                        },
                        mycontroller: nationalIdController,
                        label: "الرقم القومى الطالب",
                        hinttext: "الرقم القومى الطالب",
                        iconData: IconBroken.User,
                      ),

                    const SizedBox(height: 20),
                    if (controller.nationalIdCode != null)
                      Text("اسمك : ${controller.nameCode}"),
                    if (controller.nationalIdCode != null)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text("كودك : ${controller.nationalIdCode}"),
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: AppColor.primaryColor),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: controller.nationalIdCode.toString()),
                                ).then((_) {
                                  Get.snackbar(
                                    "نسخ",
                                    "تم نسخ الكود إلى الحافظة",
                                    backgroundColor: Colors.green[400],
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                )
            ));
          },
        ),
        backgroundColor: Colors.white,
        radius: 15,
        confirm: TextButton(
          onPressed: () {
            searchForCode(nationalIdController.text);
          },
          child: const Text(
            "بحث عن الكود",
            style: TextStyle(
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  void searchForCode(String nationalId) async {
    if (nationalId.isNotEmpty) {
      if (formState2.currentState!.validate()) {
        statusRequestCode = StatusRequest.loading;
        update();
        try {
          final response = await loginData.getGuardianCode(nationalId.trim());
          log("===================response=================== ${response.toString()}");

          statusRequestCode = handlingData(response);

          if (StatusRequest.success == statusRequestCode) {
            if (response.toString().contains("first_student_code")) {
              nationalIdCode = response['first_student_code'];
              nameCode = response['name'];
              log("nationalIdCode: $nationalIdCode");
              update();
            }
          } else {
            log("Request failed with status: $statusRequestCode");
          }
        } catch (e) {
          log("------------------//onError///------------------  $e");
        } finally {
          update();
        }
      }
    } else {
      Get.snackbar("خطأ", "الرجاء إدخال الرقم القومى");
    }
  }

  @override
  login() async {
    if (formState.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      await loginData.getToken(email.text.trim(), password.text.trim()).then(
        (value) async {
          statusRequest = handlingData(value);
          if (StatusRequest.success == statusRequest) {


            log("==============////////////////////======================== $value");
            if (value.toString().contains("token")) {
              statusRequest = StatusRequest.loading;
              myServices.sharedPreferences
                  .setString("token", value['token'].toString());
              token = myServices.sharedPreferences.getString("token") ?? "";
              myServices.sharedPreferences
                  .setString("privatetoken", value['privatetoken'].toString());
              log("==============token======================== $value");
              await getData(value['token'].toString()).then(
                (value) {
                  log(value.toString());
                },
              );
            }
            if (value.toString().contains("error")) {
              log("============================error========== $value");

              Get.defaultDialog(
                  title: "خطأ فى الادخال", middleText: "${value['error']}");
            }
          } else {}
        },
      );

      // myServices.sharedPreferences.setString("step", "2");
    }
    update();
  }

  Future getData(String token) async {
    log(token);
    statusRequest = StatusRequest.loading;
    update();

    await loginData.getData(token.toString(), email.text).then(
      (value) {
        statusRequest = handlingData(value);
        if (StatusRequest.success == statusRequest) {
          log("====================================== $value");
          userID = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][0]["VALUE"]
              .toString();
          codeSTD = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][1]["VALUE"]
              .toString();
          nameSTD = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][4]["VALUE"]
              .toString();
          emailSTD = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][5]["VALUE"]
              .toString();
          studentPhone = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][7]
                  ["VALUE"]
              .toString();
          imageUrl = value["RESPONSE"]["MULTIPLE"]["SINGLE"]["KEY"][33]["VALUE"]
              .toString();

          // Printing the extracted values
          log("ID is: $userID");
          log("Code is: $codeSTD");
          log("Name is: $nameSTD");
          log("Email is: $emailSTD");
          myServices.sharedPreferences.setString("idUserID", userID.toString());
          myServices.sharedPreferences.setString("code", codeSTD.toString());
          myServices.sharedPreferences.setString("name", nameSTD.toString());
          myServices.sharedPreferences.setString("email", emailSTD.toString());
          myServices.sharedPreferences
              .setString("studentPhone", studentPhone.toString());
          myServices.sharedPreferences
              .setString("imageUrl", imageUrl.toString());
          statusRequest = StatusRequest.loading;
          cortesStdData(token, userID.toString());
        }
      },
    ).catchError((onError) {
      log("////////////////////////////////////  $onError");
    });
  }

  Future cortesStdData(String token, String userId) async {
    statusRequest = StatusRequest.loading;
    update();
    log(token);

    try {
      final value =
          await loginData.cortesData(modelToken.toString(),token.toString(), userId.toString());

      if (value != null &&
          value['cohorts'] != null &&
          value['cohorts'].isNotEmpty) {
        cohortId = value['cohorts'][0]['cohortid'].toString();
        idNumber = value['cohorts'][0]['idnumber'].toString();
        nameCohorts = value['cohorts'][0]['name'].toString();

        myServices.sharedPreferences.setString("cohortId", cohortId);
        myServices.sharedPreferences.setString("idNumber", idNumber);
        myServices.sharedPreferences.setString("nameCohorts", nameCohorts);

        log("====================================== ${value.toString()}");
        statusRequest = StatusRequest.loading;
        setSTDData();

      } else {
        // إذا كانت cohorts فارغة، أظهر رسالة مناسبة
        log("لا توجد بيانات عن الفرق الدراسية. يرجى الذهاب إلى وحدة التعليم.");
        statusRequest = StatusRequest.none;
        showMessage(
            "لا توجد بيانات عن الفرق الدراسية. يرجى الذهاب إلى وحدة التعليم.");
      }
    } catch (e) {
      log("------------------------------------  $e");
      statusRequest = StatusRequest.none; // أو أي حالة أخرى تناسب سياقك
    }
  }

// دالة لإظهار الرسالة
  void showMessage(String message) {
    // استخدم الطريقة المناسبة لعرض الرسالة، مثل استخدام SnackBar أو AlertDialog
    Get.snackbar("تنبيه", message, snackPosition: SnackPosition.TOP);
  }

  Future setSTDData() async {
    statusRequest = StatusRequest.loading;
    update();
    await loginData
        .setData(
      idNumber.toString(),
      codeSTD.toString(),
      token.toString(),
      nameSTD.toString(),
      imageUrl.toString(),
      studentPhone.toString(),
      emailSTD.toString(),
      password.text.trim(),
      Random().nextInt(100000000).toString(),
      token.toString(),
      userID.toString(),
    )
        .then(
      (value) {
        statusRequest = handlingData(value);
        if (StatusRequest.success == statusRequest) {
          if (value['status'] == "success") {
            statusRequest = StatusRequest.loading;

            loginIn();
          }

        }
      },
    );
  }

  StudentModel studentModel = StudentModel();

  Future<void> loginIn() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      // Await the result of loginData which returns Either<StatusRequest, List<dynamic>>
      final response = await loginData.login(
          email.text.trim(), password.text.trim(), "nameSTD", "studentPhone");

      log("===================response=================== ${response.toString()}");

      // Check if the response is a failure or success
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        // The response should be the actual data here, not StatusRequest
        if (response is List) {
          // Ensure the response is not empty and is a List
          if (response.isNotEmpty) {
            // Parse the first element in the List as StudentModel
            studentModel = StudentModel.fromJson(response[0]);
            log("===================success=================== ${studentModel.studentName}");
            myServices.sharedPreferences
                .setString("idUser", studentModel.studentId.toString());
            myServices.sharedPreferences.setString(
                "studentEmail", studentModel.studentEmail.toString());
            myServices.sharedPreferences
                .setString("studentName", studentModel.studentName.toString());
            myServices.sharedPreferences.setString(
                "studentPhoto", studentModel.studentPhoto.toString());
            myServices.sharedPreferences.setString(
                "studentPhone", studentModel.studentPhone.toString());
            myServices.sharedPreferences.setString(
                "studentDepartment", studentModel.studentDepartment.toString());
            myServices.sharedPreferences
                .setString("studentBand", studentModel.studentBand.toString());
            myServices.sharedPreferences
                .setString("studentLab", studentModel.studentLab.toString());
            myServices.sharedPreferences
                .setString("chortsId", studentModel.chortsId.toString());
            myServices.sharedPreferences
                .setString("sessionId", studentModel.sessionId.toString());
            myServices.sharedPreferences
                .setString("tokenLogin", studentModel.token.toString());
            String typeInstitute = email.text[0] == "2" ? "E" : "M";
            myServices.sharedPreferences
                .setString("typeInstitute", typeInstitute.toString());
            log("typeInstitute : $typeInstitute".toString());
            // Navigate to home page with the student data
            myServices.sharedPreferences.setString("step", "2");

            Get.offNamed(AppRoute.homeScreen, arguments: {
              "studentModel": studentModel,
            });

            Get.snackbar(
                "OI Tawasol يرحب بك  ",
                translateDataBase(
                    "مرحبا بك ${myServices.sharedPreferences.getString("studentName")}",
                    "Welcome ${myServices.sharedPreferences.getString("studentName")}"),
                icon: CachedNetworkImage(
                    imageUrl: studentModel.studentPhoto.toString()),
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.zero,
                backgroundColor: AppColor.primaryColor,
                duration: const Duration(seconds: 2),
                colorText: AppColor.white,
                barBlur: 0,
                borderRadius: 0);
          } else {
            log("Response is empty, no student data found.");
            Get.snackbar(
                "Error",
                translateDataBase("لا يوجد بيانات لهذا الطالب",
                    "Response is empty, no student data found."),
                // icon: CachedNetworkImage(imageUrl: studentModel.studentPhoto.toString()),
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.zero,
                backgroundColor: AppColor.primaryColor,
                duration: const Duration(seconds: 2),
                colorText: AppColor.white,
                barBlur: 0,
                borderRadius: 0);
          }
        } else {
          log("Unexpected response format, expected a List.");
        }
      } else {
        log("Request failed with status: $statusRequest");
      }
    } catch (e) {
      log("------------------//onError///------------------  $e");
    } finally {
      update();
    }
  }

  AdminModel adminModel = AdminModel();

  Future<void> loginInAdmin() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      // Await the result of loginData which returns Either<StatusRequest, List<dynamic>>
      final response =
          await loginData.loginAdmin(email.text.trim(), password.text.trim());

      log("===================response=================== ${response.toString()}");

      // Check if the response is a failure or success
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        // The response should be the actual data here, not StatusRequest
        if (response is List) {
          // Ensure the response is not empty and is a List
          if (response.isNotEmpty) {
            // Parse the first element in the List as StudentModel
            adminModel = AdminModel.fromJson(response[0]);
            log("===================success=================== ${adminModel.adminPublisherName}");
            myServices.sharedPreferences
                .setString("email", email.text.toString());
            myServices.sharedPreferences
                .setString("password", password.text.toString());
            myServices.sharedPreferences
                .setString("idUser", adminModel.adminUserName.toString());
            log("message ID: ${myServices.sharedPreferences.getString("idUser")}");
            myServices.sharedPreferences.setString(
                "adminPublisherName", adminModel.adminPublisherName.toString());
            myServices.sharedPreferences.setString(
                "publisherImage", adminModel.publisherImage.toString());
            myServices.sharedPreferences.setString(
                "adminPassword", adminModel.adminPassword.toString());
            myServices.sharedPreferences.setString(
                "adminPermission", adminModel.adminPermission.toString());
            myServices.sharedPreferences.setString(
                "adminDepartment", adminModel.adminDepartment.toString());
            myServices.sharedPreferences.setString(
                "departmentName", adminModel.departmentName.toString());
            myServices.sharedPreferences
                .setString("sessionId", adminModel.sessionId.toString());
            myServices.sharedPreferences
                .setString("username", adminModel.username.toString());
            myServices.sharedPreferences.setString(
                "post_permission", adminModel.postPermission.toString());
            myServices.sharedPreferences
                .setString("tokenLogin", adminModel.token.toString());
            Get.snackbar(
                "OI Tawasol يرحب بك  ",
                translateDataBase(
                    "مرحبا بك ${myServices.sharedPreferences.getString("adminPublisherName")}",
                    "Welcome ${myServices.sharedPreferences.getString("adminPublisherName")}"),
                icon: CachedNetworkImage(
                  imageUrl: adminModel.publisherImage.toString(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.zero,
                backgroundColor: AppColor.primaryColor,
                duration: const Duration(seconds: 2),
                colorText: AppColor.white,
                barBlur: 0,
                borderRadius: 0);
            myServices.sharedPreferences.setString("step", "2");
            myServices.sharedPreferences.setBool("isAdmin", true);
            String typeInstitute = adminModel.adminUserName?[0] == "8"
                ? "Management"
                : "Engineering";
            myServices.sharedPreferences
                .setString("typeInstitute", typeInstitute.toString());
            log("message is Logged Admin in successfully  : $typeInstitute");
            myServices.sharedPreferences.setBool("isAdmin", true);

            Get.offNamed(AppRoute.homeAdminScreen, arguments: {
              "adminModel": adminModel,
            });
            log("message is Logged Admin in successfully");
            // await loginData
            //     .setData(
            //   adminModel.adminDepartment.toString(),
            //   adminModel.adminDepartment.toString(),
            //   adminModel.token.toString(),
            //   adminModel.adminPublisherName.toString(),
            //   adminModel.publisherImage.toString(),
            //   adminModel.adminDepartment.toString(),
            //   email.text.trim(),
            //   password.text.trim(),
            //   adminModel.sessionId.toString(),
            //   tokenFirebase.toString(),
            //   adminModel.adminUserName.toString(),
            // )
            //     .then(
            //   (value) {
            //     statusRequest = handlingData(value);
            //     if (StatusRequest.success == statusRequest) {
            //       myServices.sharedPreferences.setString("step", "2");
            //       Get.snackbar(
            //           "OI Tawasol يرحب بك  ",
            //           translateDataBase(
            //               "مرحبا بك ${myServices.sharedPreferences.getString("adminPublisherName")}",
            //               "Welcome ${myServices.sharedPreferences.getString("adminPublisherName")}"),
            //           icon: CachedNetworkImage(
            //               imageUrl: adminModel.publisherImage.toString()),
            //           snackPosition: SnackPosition.TOP,
            //           margin: EdgeInsets.zero,
            //           backgroundColor: AppColor.primaryColor,
            //           duration: const Duration(seconds: 2),
            //           colorText: AppColor.white,
            //           barBlur: 0,
            //           borderRadius: 0);
            //
            //       Get.offNamed(AppRoute.homeAdminScreen, arguments: {
            //         "adminModel": adminModel,
            //       });
            //       statusRequest = StatusRequest.success;
            //     }
            //   },
            // );
            // Navigate to home page with the student data
          } else {
            log("Response is empty, no student data found.");
            Get.snackbar(
                "Error",
                translateDataBase("لا يوجد بيانات لهذا الطالب",
                    "Response is empty, no student data found."),
                icon: CachedNetworkImage(
                  imageUrl: adminModel.publisherImage.toString(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.zero,
                backgroundColor: AppColor.primaryColor,
                duration: const Duration(seconds: 2),
                colorText: AppColor.white,
                barBlur: 0,
                borderRadius: 0);
          }
        } else {
          log("Unexpected response format, expected a List.");
        }
      } else {
        log("Request failed with status: $statusRequest");
      }
    } catch (e) {
      log("------------------//onError///------------------  $e");
    } finally {
      update();
    }
  }

  Future<void> getGuardianCode() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      // Await the result of loginData which returns Either<StatusRequest, List<dynamic>>
      final response = await loginData.getGuardianCode(email.text.trim());

      log("===================response=================== ${response.toString()}");

      // Check if the response is a failure or success
      statusRequest = handlingData(response);

      if (StatusRequest.success == statusRequest) {
        // The response should be the actual data here, not StatusRequest
      } else {
        log("Request failed with status: $statusRequest");
      }
    } catch (e) {
      log("------------------//onError///------------------  $e");
    } finally {
      update();
    }
  }

  late String tokenFirebase;
  late String modelToken;
  late bool isUpdate;
  String storeUrl = ''; // URL from Firebase
  String facebook = ''; // URL from Firebase
  String elearningOI = ''; // URL from Firebase
  String oiLink = ''; // URL from Firebase
  String youtube = ''; // URL from Firebase
  Future<void> _checkAppVersion() async {
    try {
      statusRequestLink = StatusRequest.loading;
      update();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Fetch app version info from Firebase Firestore
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await fireStore
          .collection('appInfo') // Collection in Firestore
          .doc('version') // Document containing version info
          .get();

      // Ensure the document exists and has data
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        String latestVersion = data['latestVersion'];
        modelToken = data['modeltoken'];
        isUpdate = data['update'];
        storeUrl = data['storeUrl'];
        youtube = data['youtube'];
        elearningOI = data['elearningOI'];
        oiLink = data['oiLink'];
        facebook = data['facebook'];


        log("latestVersion: $latestVersion");
        log("currentVersion: $currentVersion");
        myServices.sharedPreferences.setString("modelToken", modelToken);
        myServices.sharedPreferences.setString("facebook", facebook);
        myServices.sharedPreferences.setString("youtube", youtube);
        myServices.sharedPreferences.setString("elearningOI", elearningOI);
        myServices.sharedPreferences.setString("oiLink", oiLink);

        log("modelToken: $modelToken");
        log("facebook: $facebook");
        log("youtube: $youtube");
        log("elearningOI: $elearningOI");
        log("oiLink: $oiLink");
        update();
        statusRequestLink = StatusRequest.success;
        update();
        if(isUpdate == true && Platform.isAndroid){
          if (currentVersion != latestVersion) {
            showUpdateDialog(storeUrl);
          }
        }
      } else {
        log('Document does not exist or is missing data');
      }
    } catch (e) {
      log('Error fetching version info: $e');
    }
  }
  @override
  void onInit() async {
    _checkAppVersion();
    email = TextEditingController();
    password = TextEditingController();
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await myServices.sharedPreferences.setString("tokenFirebase", token);
        tokenFirebase = token;
        log("Firebase Token: $tokenFirebase");
      } else {
        log("Failed to fetch Firebase Token");
      }
    } catch (e) {
      log("Error fetching Firebase Token: $e");
    }


    try {
      await FirebaseMessaging.instance.subscribeToTopic("general");
      log("Subscribed to topic: general");
    } catch (e) {
      log("Error subscribing to topic: $e");
    }

    getAccessToken();
    super.onInit();
  }

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "oi-tawasol",
      "private_key_id": "3bb33ad53cc58f4e6a2d921f919403b9116029b2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCuRTF/Q3eIFYOb\npFwWtSKVBj3AkKQoSRSbfhzYUDkjOrCGpaJxOQKjnQdJw5EYbnk9WaeZQCWr8oox\njoc8JUA/1r50CZTIE91KE+2p/wq6DV+YdbJqLImxWOmUqgN7jSojg8R0oMI5nMtC\nW6upIJuwJdOJJhjeSlgdxD+nVOU9LmHKsmp6nfUy/XYZqcclWrcN6N1U5Jx4ULkV\nvGcP/X/YPzlV4jBXtUOB9QS6OBAp+cq7mHpOuDZYBw6bdUdMa8U72lMMGcI71ZdF\nWOI/pI+NSBJvDgOj1OthWvaRtCdz6H7lDAfyyyb/Vi/5/DxXdIhtHW38lUhcVRxV\n/FqxMS8nAgMBAAECggEAPTjauDJL+ldQimu13FZbJU5xgEZwHST7Y9rsqEOapxk1\nrb/frvYPysneJxhYz2P0HMzz159U/LCywtEnCkat6R94fgxlo9pyqdURb+DE9HLB\nTC7A9JLb9p1dRdhqa8u+a4adjDlzski2kYPh7QMjHsFTLMHhB6rHhQGOOStWc2TU\ngrI8eL23Fh6UOhRjr++gXN2GzfLwxAJNBuLSA0C0CZupWlugHVyN5tJMws2qHXWj\n+lQhKxHNkRPlHw5si6MTCASU/DlHMemOsmnAYG9nu981ki34oqFWNYfG3CZ46Ma4\nI7bmN3M2Qu2OlmzTWWG31hy1qVNRYHxf3LGzt6pM6QKBgQDmujLzT4GlxjjVVANu\nSRNvKGyABGVhvvVF/uqt7y+bHVAxWCBr8JnXjho0Wd2kE0LK6WA4spGIug5MuTGs\n+v8dj7pA9twPVU+8nYq1DYIkgMg0cOYak2z4GSJd6sGcCMIZHi3gcHHx889xgP0+\neLv4U7cvPk1ULGft4vF5H074KQKBgQDBW+NXOTrP0ZPLdNif5YgVxZBtTzt0zK5y\njxRLT06xj/TO2aAurdP+0fpuHbCLwSUph3cLtUIeWWDpvws9NM13hSsYXKI3VnBo\n5vITqhQM6WLV/QEt3idZrG/8uBQHbrCi6nFdt2G2AKMhf9L6tbrP5Ce7CZc94Y0H\n68ioK0sWzwKBgQCkm4rmE38Hahf5+mpIMFJxJ4HhA0HhLn+GZIvBc7efDpa73Yej\n+o+HPZZsawC5ohQw97byPFOgHD0/d5B9PMTtrjDPUE9HkTHF+w+OhAipSkeLQlCn\n/S3tAuGF54ohbA4uJV3Nlet1FuCUtdX2z+QrEm7KgcRhnRy4lwR3yWJpoQKBgGlE\n/aCfJ8W89Bnwo39qF4zC4r6gRF5ykQcNnp7hrpY9Kar0EKFZQfGZoB4TS+rKXNEf\nT1Cwfi7HuluIBzZraPGJLs00oZw/EzQJiAHstr3Q0l5uQBYYvJO1rcKI9V6WhNQt\nj0rWa/wKnMXAMb0M84f7TyYlMpIeGgoV9EiaSWdBAoGADBZh77/nwkz6HvAMGJLm\nn8QrjLHNz7shmvcpeqNYipVmsqn9yC6aGpdRT7DE4fdAWAAXxaCyvC8X0c33G7iP\ndsgJdZSawbkfuBfxt/EvZuQnMkNfyVaMxlkOM1XpGhEWyRM+Hl8QzQmsZ3x850x7\n6BERr+kY0MsJ6I4i8ndRVH8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-rwbtv@oi-tawasol.iam.gserviceaccount.com",
      "client_id": "103261302360031868448",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-rwbtv%40oi-tawasol.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      log("Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      log("Error getting access token: $e");
      return null;
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}

import '../../../../../../core/class/crud.dart';
import '../../../../../../likeapi.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  Future getToken(String username, String password) async {
    var response = await crud.getData(
        "https://elearning.oi.edu.eg/login/token.php?service=moodle_mobile_app&username=$username&password=$password",
        {});
    return response.fold((l) => l, (r) => r);
  }



  Future getData(String token, String code) async {
    var response = await crud.getDataXML(
        "${AppLink.dataSTD}?wstoken=$token&wsfunction=core_user_get_users_by_field&field=username&values[0]=$code",
        {});
    return response.fold((l) => l, (r) => r);
  }

  Future cortesData(String wstoken,String token, String userId) async {
    var response = await crud.getData(
        "${AppLink.dataSTD}?wstoken=$wstoken&wsfunction=local_wsgetusercohorts&userid=$userId&moodlewsrestformat=json",
        {});
    return response.fold((l) => l, (r) => r);
  }

  Future setData(
    String chortsId,
    String studentId,
    String studentToken,
    String studentName,
    String studentPhoto,
    String studentPhone,
    String studentEmail,
    String studentPassword,
    String sessionId,
    String token,
    String userId,
  ) async {
    var response = await crud.postData("${AppLink.setSTDData}?token=$token&user_id=$userId&chortsId=$chortsId", {
      "chortsId": chortsId,
      "studentId": studentId,
      "studentToken": studentToken,
      "studentName": studentName,
      "studentPhoto": studentPhoto,
      "studentPhone": studentPhone,
      "studentEmail": studentEmail,
      "studentPassword": studentPassword,
      "sessionId": sessionId,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future login( String userName,String password,String name,String sub) async {
    var response = await crud.postData("https://tawasol.obourtawasol.com/studentLogin.php", {
      "userName": userName.toString(),
      "password": password.toString(),
      "sub": sub.toString(),
      "name": name.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  Future loginAdmin( String userName,String password) async {
    var response = await crud.postData("https://tawasol.obourtawasol.com/admin2.php", {
      "adminName": userName.toString(),
      "password": password.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  Future getGuardianCode(String username) async {
    var response = await crud.postData(
        AppLink.getGuardianCode,
        {
          "username": username.toString(),
        });
    return response.fold((l) => l, (r) => r);
  }
}



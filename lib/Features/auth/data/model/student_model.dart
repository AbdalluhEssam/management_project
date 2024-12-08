class StudentModel {
  String? studentId;
  String? studentEmail;
  String? studentName;
  String? studentPhoto;
  String? studentPhone;
  String? studentDepartment;
  String? studentBand;
  String? studentLab;
  String? chortsId;
  String? sessionId;
  String? token;

  StudentModel({
    this.studentId,
    this.studentEmail,
    this.studentName,
    this.studentPhoto,
    this.studentPhone,
    this.studentDepartment,
    this.studentBand,
    this.studentLab,
    this.chortsId,
    this.sessionId,
    this.token,
  });

  // Factory method to parse from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'],
      studentEmail: json['studentEmail'],
      studentName: json['studentName'],
      studentPhoto: json['studentPhoto'],
      studentPhone: json['studentPhone'],
      studentDepartment: json['studentDepartment'],
      studentBand: json['studentBand'],
      studentLab: json['studentLab'],
      chortsId: json['chortsId'],
      sessionId: json['sessionId'],
      token: json['token'],
    );
  }
}


class AdminModel {
  String? adminUserName;
  String? adminPublisherName;
  String? publisherImage;
  String? adminPassword;
  String? adminPermission;
  String? adminDepartment;
  String? departmentName;
  String? sessionId;
  String? username;
  String? postPermission;
  String? token;

  AdminModel(
      {this.adminUserName,
        this.adminPublisherName,
        this.publisherImage,
        this.adminPassword,
        this.adminPermission,
        this.adminDepartment,
        this.departmentName,
        this.sessionId,
        this.username,
        this.postPermission,
        this.token});

  AdminModel.fromJson(Map<String, dynamic> json) {
    adminUserName = json['adminUserName'];
    adminPublisherName = json['adminPublisherName'];
    publisherImage = json['publisherImage'];
    adminPassword = json['adminPassword'];
    adminPermission = json['adminPermission'];
    adminDepartment = json['adminDepartment'];
    departmentName = json['departmentName'];
    sessionId = json['sessionId'];
    username = json['username'];
    postPermission = json['post_permission'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adminUserName'] = adminUserName;
    data['adminPublisherName'] = adminPublisherName;
    data['publisherImage'] = publisherImage;
    data['adminPassword'] = adminPassword;
    data['adminPermission'] = adminPermission;
    data['adminDepartment'] = adminDepartment;
    data['departmentName'] = departmentName;
    data['sessionId'] = sessionId;
    data['username'] = username;
    data['post_permission'] = postPermission;
    data['token'] = token;
    return data;
  }
}

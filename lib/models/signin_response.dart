class SigninResponse {
  String? message;
  int? type;
  int? code;
  List<Data>? data;

  SigninResponse({this.message, this.type, this.code, this.data});

  SigninResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    type = json['type'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['type'] = type;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? avatar;
  String? firstName;
  String? lastName;
  String? gender;
  int? role;
  String? email;
  String? phone;
  String? loginOtp;
  String? loginOtpExpire;
  String? createdAt;
  String? updatedAt;
  String? roleName;

  Data(
      {this.id,
      this.avatar,
      this.firstName,
      this.lastName,
      this.gender,
      this.role,
      this.email,
      this.phone,
      this.loginOtp,
      this.loginOtpExpire,
      this.createdAt,
      this.updatedAt,
      this.roleName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    role = json['role'];
    email = json['email'];
    phone = json['phone'];
    loginOtp = json['Login_otp'];
    loginOtpExpire = json['Login_otp_expire'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['role'] = role;
    data['email'] = email;
    data['phone'] = phone;
    data['Login_otp'] = loginOtp;
    data['Login_otp_expire'] = loginOtpExpire;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['roleName'] = roleName;
    return data;
  }
}

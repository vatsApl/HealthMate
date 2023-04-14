class SignupResponse {
  String? message;
  String? status;
  int? type;
  int? code;
  Data? data;

  SignupResponse({this.message, this.status, this.type, this.code, this.data});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    type = json['type'];
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['type'] = type;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? role;
  String? gender;
  String? createdAt;
  String? updatedAt;
  int? loginOtp;
  String? loginOtpExpire;
  int? id;

  Data(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.role,
      this.gender,
      this.createdAt,
      this.updatedAt,
      this.loginOtp,
      this.loginOtpExpire,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loginOtp = json['Login_otp'];
    loginOtpExpire = json['Login_otp_expire'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['Login_otp'] = loginOtp;
    data['Login_otp_expire'] = loginOtpExpire;
    data['id'] = id;
    return data;
  }
}

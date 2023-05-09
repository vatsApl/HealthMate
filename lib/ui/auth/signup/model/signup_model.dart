class SignupModel {
  String? message;
  String? status;
  int? type;
  int? code;
  Data? data;

  SignupModel({this.message, this.status, this.type, this.code, this.data});

  SignupModel.fromJson(Map<String, dynamic> json) {
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
  String? practiceName;
  String? email;
  String? phone;
  String? address;
  String? otp;
  String? otpExpire;
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
      this.practiceName,
      this.email,
      this.phone,
      this.address,
      this.otp,
      this.otpExpire,
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
    practiceName = json['practice_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    otp = json['otp'];
    otpExpire = json['otp_expire'];
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
    data['practice_name'] = practiceName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['otp'] = otp;
    data['otp_expire'] = otpExpire;
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
